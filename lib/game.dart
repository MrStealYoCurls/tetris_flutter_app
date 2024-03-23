// Necessary imports for Flutter and game functionality
// import 'package:flutter/foundation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import 'main.dart';
import 'block.dart';
import 'sub_block.dart';

// Enum for identifying different types of collisions
enum CollisionType { hitBlock, hitWall, none }
var status = CollisionType.none;

// Game configuration constants
const column = 10;
const row = 20;
const gameAreaBorderWidth = 2.0;
const subBlockEdgeWidth = 2.0;
int refreshRate = 400;
int level = 1;
bool _isPlaying = false;
bool _isPaused = false;
int lastTimestamp = 0;

// Game widget
class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<StatefulWidget> createState() => GameState();
}

class GameState extends State<Game> {
  final GlobalKey _keyGameArea = GlobalKey();
  late Block block;
  late TimerManager timerManager;
  late List<SubBlock> oldSubBlocks;
  double subBlockWidth = 20.0;
  bool isLayoutInitialized = false;
  bool isGameOver = false;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  BlockMovement action = BlockMovement.none;

  @override
  void initState() {
    super.initState();
    block = getNewBlock();
    timerManager = TimerManager(Duration(milliseconds: refreshRate), onPlay);
  }

 
  
  // Generates a new block randomly
  Block getNewBlock() {
    int blockType = Random().nextInt(7);
    int orientationIndex = Random().nextInt(4);

    switch (blockType) {
      case 0:
        return IBlock(orientationIndex);
      case 1:
        return JBlock(orientationIndex);
      case 2:
        return LBlock(orientationIndex);
      case 3:
        return OBlock(orientationIndex);
      case 4:
        return TBlock(orientationIndex);
      case 5:
        return SBlock(orientationIndex);
      case 6:
        return ZBlock(orientationIndex);
      default:
        throw Exception('Invalid block type');
    }
  }

  @override
  void dispose() {
    timerManager.cancel();
    super.dispose();
  }

  // Starts the game
  void startGame() {
    _isPlaying = true;
    isGameOver = false;
    oldSubBlocks = [];
    block = getNewBlock();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox? renderBoxGame = _keyGameArea.currentContext!.findRenderObject() as RenderBox?;
      if (renderBoxGame != null) {
        setState(() {
          subBlockWidth = (renderBoxGame.size.width - gameAreaBorderWidth * 2) / column;
          isLayoutInitialized = true;
        });
        block = getNewBlock();
        timerManager.time();
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          startGame();
        });
      }
    });
  }

  // Ends the game
  void endGame() {
    _isPlaying = false;
    if (timerManager.isActive) {timerManager.cancel();}
  }

  // Pauses or resumes the game
  void pauseGame() {
    if (!isPaused) {
      timerManager.cancel();
      _isPaused = true;
    } else {
      timerManager.time();
      _isPaused = false;
    }
  }

  // Main game loop, executed on each timer tick
  void onPlay(Timer timer) {
    status = CollisionType.none;
    if (!mounted || !isPlaying) {
      timer.cancel();
      return;
    }
    setState(() {
      // Handle block movement and collision
      if (!checkOnEdge(action)) {
        block.move(action);
      } 

      if (collision()) {
        switch (action) {
          case BlockMovement.left:
            block.move(BlockMovement.right);
            break;
          case BlockMovement.right:
            block.move(BlockMovement.left);
            break;
          case BlockMovement.rotate:
            block.move(BlockMovement.rotate);
            checkOnEdge(BlockMovement.rotate);
            break;
          default:
            break;
        }
      }

      // Handling block landing on the bottom or on top of another block
      if (!collision()) {
        block.move(BlockMovement.down);
        } else {
        status = CollisionType.hitBlock;
      }

      // Game over condition if a block lands above the play area
      if (status == CollisionType.hitBlock && block.y < 0) {
        isGameOver = true;
        endGame();

      // On block landing, add its sub-blocks to oldSubBlocks and get a new block
      } else if (status == CollisionType.hitBlock) {
        updateOldSubBlocks();
        block = Provider.of<Data>(context, listen: false).nextBlock;
        Provider.of<Data>(context, listen: false).setNextBlock(getNewBlock());
      }

      action = BlockMovement.none; // Reset action after handling
      updateScore(); // Update the score based on cleared lines
    });
  }
  
  void updateScore() {
    var combo = 1; // Reset combo for each scoring
    Map<int, int> rows = {};
    List<int> rowsToBeRemoved = [];

    for (var subBlock in oldSubBlocks) {
      rows.update(subBlock.y, (value) => ++value, ifAbsent: () => 1);
    }

    int linesCleared = 0;
    rows.forEach((rowNum, count) {
      if (count == column) {
        linesCleared++;
        rowsToBeRemoved.add(rowNum);
      }
    });

    if (rowsToBeRemoved.isNotEmpty) {
      removeRows(rowsToBeRemoved);

      // Calculate score based on lines cleared and combo
      var points = calculatePoints(linesCleared, combo);
      Provider.of<Data>(context, listen: false).addScore(points);

      // Check and handle level up
      var dataProvider = Provider.of<Data>(context, listen: false);
      if (dataProvider.score >= 100 * level) {
        level += level;
        adjustSpeed();
      }
    }
  }

  void adjustSpeed() {
    refreshRate -= 25;
  }

  int calculatePoints(int linesCleared, int combo) {
    int basePoints = 10;
    double comboBonusMultiplier = 1.5;
    int score;

    if (linesCleared > 1) {
      score = basePoints;
      for (int i = 1; i < linesCleared; i++) {
        score += (basePoints * comboBonusMultiplier).toInt() * i;
      }
    } else {
      score = basePoints;
    }

    return score * combo;
  }

  // Removes completed rows and updates score
  void removeRows(List<int> rowsToBeRemoved) {
    rowsToBeRemoved.sort();
    for (var rowNum in rowsToBeRemoved) {
      oldSubBlocks.removeWhere((subBlock) => subBlock.y == rowNum);
      for (var subBlock in oldSubBlocks) {
        if (subBlock.y < rowNum) {
          ++subBlock.y; // Move down blocks above the removed row
        }
      }
    }
  }

  // Instantly drops the block
  void dropBlock() {
    setState(() {    
      int maxDropDistance = row; // How far the block can drop without collision
      
      for (var subBlock in block.subBlocks) {
        for (int dropDistance = 1; dropDistance < row - block.y - subBlock.y; dropDistance++) {
          bool collisionDetected = oldSubBlocks.any((oldSubBlock) => 
            oldSubBlock.x == block.x + subBlock.x && 
            oldSubBlock.y == block.y + subBlock.y + dropDistance
          );
          if (collisionDetected) {
            maxDropDistance = min(dropDistance - 1, maxDropDistance);
            break;
          }
          if (block.y + subBlock.y + dropDistance == row - 1) {
            maxDropDistance = min(dropDistance, maxDropDistance);
            break;
          }
        }
      }
      // Drop the block to the new position
      block.y += maxDropDistance; // Updates the Y position of each sub-block
      placeBlock(); // Check and handle if the block has landed
    });
  }

  placeBlock() {
    if (collision()) {block.y; updateOldSubBlocks();}
    block = Provider.of<Data>(context, listen: false).nextBlock;
    Provider.of<Data>(context, listen: false).setNextBlock(getNewBlock());
  }

  // Checks if the block is at the bottom of the play area or on top of another block
  bool collision() {
    if ( block.y + block.height == row ) return true;

    for (var oldSubBlock in oldSubBlocks) {
      for (var subBlock in block.subBlocks) {
        var x = block.x + subBlock.x;
        var y = block.y + subBlock.y;
        if (x == oldSubBlock.x && y + 1 == oldSubBlock.y) {
          return true;
        }
      }
    }
    return false;
  }

  // Adds the current block's sub-blocks to the oldSubBlocks list
  void updateOldSubBlocks() {
    block.subBlocks.forEach((subBlock) {
      subBlock.x += block.x;
      subBlock.y += block.y;
      oldSubBlocks.add(subBlock);
    });
  }

  // Checks if the block is on the edge of the play area to prevent it from moving out of bounds
  bool checkOnEdge(BlockMovement action) {
    return (action == BlockMovement.left && block.x <= 0) ||
           (action == BlockMovement.right && block.x + block.width >= column);
  }

  // Renders a sub-block at a specific position with a given color
  Widget getPositionedSquareContainer(Color color, int x, int y) {
    return Positioned(
      left: x * subBlockWidth,
      top: y * subBlockWidth,
      child: Container(
        width: subBlockWidth - subBlockEdgeWidth,
        height: subBlockWidth - subBlockEdgeWidth,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        ),
      ),
    );
  }

  // Draws both the current moving block and the old static blocks
  Widget drawBlocks() {
    if (!isLayoutInitialized) {
      return Container();
    }
    List<Widget> subBlocks = [];
    block.subBlocks.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(
          subBlock.color, subBlock.x + block.x, subBlock.y + block.y));
    });

    // Old sub-blocks
    for (var oldSubBlock in oldSubBlocks) {
      subBlocks.add(getPositionedSquareContainer(
          oldSubBlock.color, oldSubBlock.x, oldSubBlock.y));
    }

    // Display "Game Over" message overlay if the game has ended
    if (isGameOver) {
      subBlocks.add(getGameOverRect());
    }

    return Stack(
      children: subBlocks,
    );
  }
  
  // Creates a "Game Over" overlay with styling
  Widget getGameOverRect() {
    return Positioned(
        left: subBlockWidth * 1.0,
        top: subBlockWidth * 6.0,
        child: Container(
          width: subBlockWidth * 8.0,
          height: subBlockWidth * 3.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: const Text(
            'Game Over',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      );
  }

  // Handles swipe and tap gestures for controlling the game
  @override
  Widget build(BuildContext context) {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          action = BlockMovement.right;
        } else {
          action = BlockMovement.left;
        }
      },
      onTap: () {
        action = BlockMovement.rotate;
      },
      onVerticalDragUpdate: (details) {
      // Detect swipe down with significant vertical movement
      if (details.primaryDelta! > 15 && currentTimestamp - lastTimestamp > 500) {
        dropBlock();
        lastTimestamp = currentTimestamp;
      }
    },
    child: AspectRatio(
            aspectRatio: column / row,
            child: Container(
              key: _keyGameArea,
              decoration: BoxDecoration(
                  color: HexColor("#343841"),
                  border: Border.all(
                    width: gameAreaBorderWidth,
                    color: Colors.orangeAccent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                  child: drawBlocks(),
            ),
          )
    );
  }
}

class TimerManager {
  Timer? _timer;
  final Duration _duration;
  final Function(Timer) _callback;

  TimerManager(this._duration, this._callback);

  void time() {
    _timer?.cancel();
    _timer = Timer.periodic(_duration, _callback);
  }

  void cancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  bool get isActive => _timer?.isActive ?? false;
}

