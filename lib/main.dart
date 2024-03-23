import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tetris_flutter_app/block.dart';
import 'score_bar.dart';
import 'game.dart';
import 'next_block.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => Data(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Tetris(),
    );
  }
}

class Tetris extends StatefulWidget {
  const Tetris({super.key});
  @override
  TetrisState createState() => TetrisState();
}

class TetrisState extends State<Tetris> {
  late Game gameWidget;

  final GlobalKey<GameState> _keyGame = GlobalKey();

  @override
  void initState() {
    super.initState();
    gameWidget = Game(key: _keyGame);
    // final data = Provider.of<Data>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TETRIS", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: HexColor("#17191E"),
      ),
      backgroundColor: HexColor("#17191E"),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const ScoreBar(),
            Expanded(
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
                        child: Game(key: _keyGame),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const NextBlock(),
                            const SizedBox(height: 30),
                            Consumer<Data>(
                              builder: (context, data, child) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    minimumSize: const Size(100, 50),
                                  ),
                                  onPressed: () {
                                    if (_keyGame.currentState != null) {
                                      if (!_keyGame.currentState!.isPlaying) {
                                        _keyGame.currentState!.startGame();
                                      } else if (!_keyGame.currentState!.isPaused){
                                        _keyGame.currentState!.pauseGame();
                                      } else if (_keyGame.currentState!.isPaused) {
                                        _keyGame.currentState!.pauseGame();
                                      }
                                    }
                                  },

                                  child: Text(
                                    _keyGame.currentState!.isPlaying ? 'Pause' : 'Start',
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data with ChangeNotifier {
  int score = 0;
  late Block currentBlock = getNewBlock();
  late Block nextBlock;
  
  Data() {
    currentBlock = getNewBlock();
    nextBlock = getNewBlock();
  }

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

  void setScore(int score) {
    this.score = score;
    notifyListeners();
  }

  void addScore(int score) {
    this.score += score;
    notifyListeners();
  }

  void setNextBlock(Block nextBlocks) {
    nextBlock = nextBlocks;
    notifyListeners();
  }

  Widget getNextBlockWidget() {
    // Game gameWidget;
    // if (!gameWidget.gameState.isPlaying) return Container();

    var width = nextBlock.width;
    var height = nextBlock.height;
    Color color;

    List<Widget> columns = [];
    for (var y = 0; y < height; ++y) {
      List<Widget> rows = [];
      for (var x = 0; x < width; ++x) {
        if (nextBlock.subBlocks
                .where((subBlock) => subBlock.x == x && subBlock.y == y)
                .isNotEmpty) {
          color = nextBlock.color;
        } else {
          color = Colors.transparent;
        }

        rows.add(Container(width: 12, height: 12, color: color));
      }

      columns.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: rows),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }
}
