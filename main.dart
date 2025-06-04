import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int _crossAxisCount = 20;
  final int _mainAxisCount = 20;

  List<int> _snake = [0, 1, 2];
  int _food = 30;
  bool _isGameOver = false;
  String _direction = 'right';

  void _startGame() {
    _isGameOver = false;
    _snake = [0, 1, 2];
    _food = Random().nextInt(_crossAxisCount * _mainAxisCount);
    _direction = 'right';

    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_isGameOver) {
        timer.cancel();
      } else {
        _moveSnake();
      }
    });
  }

  void _moveSnake() {
    setState(() {
      if (_direction == 'right') {
        _snake.insert(0, _snake.first + 1);
      } else if (_direction == 'left') {
        _snake.insert(0, _snake.first - 1);
      } else if (_direction == 'up') {
        _snake.insert(0, _snake.first - _crossAxisCount);
      } else if (_direction == 'down') {
        _snake.insert(0, _snake.first + _crossAxisCount);
      }

      if (_snake.first == _food) {
        _food = Random().nextInt(_crossAxisCount * _mainAxisCount);
      } else {
        _snake.removeLast();
      }

      if (_snake.first < 0 ||
          _snake.first >= _crossAxisCount * _mainAxisCount ||
