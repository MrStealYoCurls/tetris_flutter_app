import 'package:flutter/material.dart';
import 'sub_block.dart';

enum BlockMovement {up, down, left, right, rotate, none,}

class Block {
  List<List<SubBlock>> orientations = [];
  late int x;
  late int y;
  int orientationIndex;

  Block(this.orientations, Color color, this.orientationIndex) {
    x = 3;
    y = -height;
    this.color = color;
  }

  set color(Color color) {
    for (var orientation in orientations) {
      for (var subBlock in orientation) {
        subBlock.color = color;
      }
    }
  }

  Color get color => orientations[0][0].color;


  get subBlocks {
    return orientations[orientationIndex];
  }

  get width {
    int maxX = 0;
    subBlocks.forEach((subBlock){
      if (subBlock.x > maxX) maxX = subBlock.x;
    });
    return maxX + 1;
  }

  get height {
    int maxY = 0;
    subBlocks.forEach((subBlock){
      if (subBlock.y > maxY) maxY = subBlock.y;
    });
    return maxY + 1;
  }

  void move(BlockMovement blockMovement) {
    switch (blockMovement) {
      case BlockMovement.up:
        y -= 1;
        break;
      case BlockMovement.down:
        y += 1;
        break;
      case BlockMovement.left:
        x -= 1;
        break;
      case BlockMovement.right:
        x += 1;
        break;
      case BlockMovement.rotate:
        orientationIndex = ++orientationIndex % 4;
        break;
      case BlockMovement.none:
        break;
    }
  }
}

class IBlock extends Block {
  IBlock(int orientationIndex)
    : super([
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
    ], Colors.red, orientationIndex);
}

class JBlock extends Block {
  JBlock(int orientationIndex)
    : super([
      [SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2), SubBlock(0, 2)],
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(0, 2)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(2, 1)],
    ], Colors.yellow, orientationIndex);
}

class LBlock extends Block {
  LBlock(int orientationIndex)
    : super([
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 2)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
      [SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
    ], Colors.green, orientationIndex);
}

class OBlock extends Block {
  OBlock(int orientationIndex)
    : super([
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    ], Colors.blue, orientationIndex);
}

class TBlock extends Block {
  TBlock(int orientationIndex)
    : super([
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(1, 1)],
      [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
      [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
    ], Colors.cyan, orientationIndex);
}

class SBlock extends Block {
  SBlock(int orientationIndex)
    : super([
      [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
      [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
      [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
    ], Colors.orange, orientationIndex);
}

class ZBlock extends Block {
  ZBlock(int orientationIndex)
    : super([
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
      [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
      [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
      [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
    ], Colors.purple, orientationIndex);
}