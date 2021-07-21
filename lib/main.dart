import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_game_wood_cutter/constants/game_constants.dart'
    as constants;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (detail) {
          print(detail.kind);
          print(
              detail.globalPosition.dx > (screenWidth / 2) ? 'right' : 'left');
        },
        child: Stack(
          children: [
            ...[
              Container(
                color: Color.fromRGBO(107, 248, 121, 1.0),
                width: screenWidth,
                height: screenHeight,
              ),
              Positioned(
                  left: (screenWidth / 2) - (constants.THICKNESS / 2),
                  child: Container(
                    width: constants.THICKNESS,
                    height: screenHeight,
                    color: Colors.brown,
                  ))
            ],
            ...[
              Container(
                color: Color.fromRGBO(248, 76, 76, 1.0),
                width: 50,
                height: 50,
              ),
            ]
          ],
          fit: StackFit.loose,
        ),
      ),
    );
  }
}
