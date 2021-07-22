import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  int score;

  ResultPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Result Page'),
      ),
      body: Center(
        child: Text(
          'Your score is : $score',
          style: TextStyle(
            fontSize: 30,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
