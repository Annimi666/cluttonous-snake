import 'dart:async';
import 'dart:math';
// import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/piece.dart';
import 'package:test_flutter/direction.dart';

import 'control_pannel.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin{
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 30; //开始小蛇的长度
  int length = 5;
  Offset foodPosition = null as Offset; //Offset foodPosition
  late Piece food;
  int score = 0;
  double speed = 1.0;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer ? timer; //Timer timer
//给蛇赋初始速度
  void changeSpeed() {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {});
    });
  }

  Widget getControls() {
    return ControlPannel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }

//定义一个随机方向
  Direction getRandomDirection() {
    int val = Random().nextInt(4);
    direction = Direction.values[val];
    return direction;
  }
//当游戏结束后，给蛇的各项属性赋初值
  void restart() {
    length = 5;
    score = 0;
    speed = 1;
    positions = [];
    direction = getRandomDirection();
    changeSpeed();
  }

  @override
  initState() {
    super.initState();
    restart();
  }
//获取整十的数字，使蛇和食物的位置能够精准对接
  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step; //20.4 408/20 /20*20=400
    if (output == 0) {
      output += step;
    }
    return output;
  }
//获取随机位置
  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]); //添加到列表
    }
    //将后一个位置前移，所有位置一直未发生改变
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
      //4<--3
      //3<--2
      //2<--1
      //1<--0
    }
    //400,400,400,400,20,440
    positions[0] = await getNextPosition(positions[0]);
  }

//检测碰撞
  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }
//显示游戏结束的画面
  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Game Over",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Your game is over but you played well. Your score is " +
                score.toString() +
                '.',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: const Text(
                "Restart",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),//
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Offset> getNextPosition(Offset position) async {
    Offset nextPosition = Offset.zero;
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    if (detectCollision(position) == true) {
      if (timer != null) {
        timer?.cancel();
      }
      await Future.delayed(
          const Duration(milliseconds: 200), () => showGameOverDialog());
      return position;
    }
    return nextPosition;
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }
    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      posY: foodPosition.dy.toInt(),
      posX: foodPosition.dx.toInt(),
      size: step,
      color: Colors.red,
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw(); //5
    drawFood(); //5
    for (var i = 0; i < length; ++i) {
      if (i > positions.length) {
        continue;
      }
      pieces.add(Piece(
        posX: positions[i].dx.toInt(),
        posY: positions[i].dy.toInt(),
        size: step,
        color: i.isEven ? Colors.red : Colors.green,
        isAnimated: false,
      ));
    }

    return pieces;
  }

  Widget getScore() {
    return Positioned(
        top: 80.0,
        right: 50.0,
        child: Text(
          "Score :" + score.toString(),
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundY = step;
    lowerBoundX = step;

    upperBoundY = getNearestTens(screenHeight.toInt() - step); //906
    upperBoundX = getNearestTens(screenWidth.toInt() - step); //408
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControls(),
            food,
            getScore(),
          ],
        ),
      ),
    );
  }
}