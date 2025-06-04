import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData.dark(),
      home: SnakeGame(),
    );
  }
}

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  SnakeGameState createState() => SnakeGameState();
}

class SnakeGameState extends State<SnakeGame> {
  static const int rowCount = 20;
  static const int totalSquares = rowCount * rowCount;

  List<int> snakePosition = [45, 65, 85];
  int foodPosition = Random().nextInt(totalSquares);
  Direction direction = Direction.down;
  Timer? timer;

  int score = 0; // ✅ Score counter

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: 300), (Timer timer) {
      setState(() {
        updateSnake();
      });
    });
  }

  void updateSnake() {
    int newHead;
    switch (direction) {
      case Direction.down:
        newHead = snakePosition.last + rowCount;
        break;
      case Direction.up:
        newHead = snakePosition.last - rowCount;
        break;
      case Direction.left:
        newHead = snakePosition.last - 1;
        break;
      case Direction.right:
        newHead = snakePosition.last + 1;
        break;
    }

    // Game over conditions
    if (snakePosition.contains(newHead) ||
        newHead < 0 ||
        newHead >= totalSquares ||
        (direction == Direction.right && newHead % rowCount == 0) ||
        (direction == Direction.left && (newHead + 1) % rowCount == 0)) {
      timer?.cancel();
      showGameOver();
      return;
    }

    snakePosition.add(newHead);
    if (newHead == foodPosition) {
      foodPosition = Random().nextInt(totalSquares);
      score++; // ✅ Increase score
    } else {
      snakePosition.removeAt(0);
    }
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'), // ✅ removed `const`
        content: Text('Your Score: $score'),
        actions: [
          TextButton(
            child: Text('Restart'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                snakePosition = [45, 65, 85];
                direction = Direction.down;
                foodPosition = Random().nextInt(totalSquares);
                score = 0; // ✅ Reset score
                startGame();
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0 && direction != Direction.up) {
          direction = Direction.down;
        } else if (details.delta.dy < 0 && direction != Direction.down) {
          direction = Direction.up;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0 && direction != Direction.left) {
          direction = Direction.right;
        } else if (details.delta.dx < 0 && direction != Direction.right) {
          direction = Direction.left;
        }
      },
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Score: $score', // ✅ Score display
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: totalSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowCount,
              ),
              itemBuilder: (context, index) {
                if (snakePosition.contains(index)) {
                  return Container(
                    padding: EdgeInsets.all(1),
                    child: Container(color: Colors.green),
                  );
                } else if (index == foodPosition) {
                  return Container(
                    padding: EdgeInsets.all(1),
                    child: Container(color: Colors.red),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(1),
                    child: Container(color: Colors.grey[900]),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
