import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_game_wood_cutter/constants/game_constants.dart'
    as constants;
import 'package:flutter_app_game_wood_cutter/screen/result_screen.dart';
import 'package:flutter_app_game_wood_cutter/util/game_logic.dart';

class GameViewModel extends StatefulWidget {
  late final double screenWidth;
  late final double screenHeight;
  late GameLogic gameLogic;

  GameViewModel({required this.screenWidth, required this.screenHeight}) {
    this.gameLogic =
        GameLogic(screenWidth: screenWidth, screenHeight: screenHeight);
  }

  @override
  _GameViewModelState createState() => _GameViewModelState();
}

class _GameViewModelState extends State<GameViewModel> {
  bool isFirst = true;
  late double percentage;
  late bool isGameOver;
  late int score;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      widget.gameLogic = GameLogic(
          screenWidth: widget.screenWidth, screenHeight: widget.screenHeight);
      percentage = 1;
      score = 0;
      isGameOver = false;
      Timer.periodic(Duration(milliseconds: 10), (timer) async {
        setState(() {
          percentage -= (1 / (constants.PLAY_TIME_SECONDS * 100));
        });
        if (percentage <= 0 || isGameOver) {
          timer.cancel();
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultPage(score: score)));
          setState(() {
            isFirst = true;
          });
        }
      });
      isFirst = false;
    }
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (detail) async {
          print(detail.kind);
          setState(() {
            isGameOver = detail.globalPosition.dx > (widget.screenWidth / 2)
                ? widget.gameLogic.nextMove(Position.RIGHT)
                : widget.gameLogic.nextMove(Position.LEFT);
          });
          if (!isGameOver) {
            setState(() {
              score++;
              if (percentage + constants.BONUS_FOR_SCORE >= 1) {
                percentage = 1;
              } else {
                percentage += constants.BONUS_FOR_SCORE;
              }
            });
          }
        },
        child: Stack(
          children: [
            ...[
              Container(
                color: Color.fromRGBO(107, 248, 121, 1.0),
                width: widget.screenWidth,
                height: widget.screenHeight,
              ),
              Positioned(
                  left: (widget.screenWidth / 2) - (constants.TRUNK_WIDTH / 2),
                  child: Container(
                    width: constants.TRUNK_WIDTH,
                    height: widget.screenHeight,
                    color: Colors.brown,
                  )),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: widget.screenWidth,
                    height: constants.FLOOR_HEIGHT,
                    color: Colors.brown,
                  )),
            ],
            ...getGameElements(widget.gameLogic, widget),
            ...[
              Positioned(
                  top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: 10))),
                    width: widget.screenWidth,
                    height: constants.TIMER_HEIGHT,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: HSVColor.lerp(
                              HSVColor.fromColor(Color.fromRGBO(255, 0, 0, 1)),
                              HSVColor.fromColor(Color.fromRGBO(0, 255, 0, 1)),
                              percentage)!
                          .toColor(),
                      value: percentage,
                    ),
                  )),
              Center(
                child: Center(
                  child: Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.limeAccent[700],
                    ),
                  ),
                ),
              )
            ]
          ],
          fit: StackFit.loose,
        ),
      ),
    );
  }
}

List<Widget> getGameElements(GameLogic gameLogic, GameViewModel widget) {
  List<Widget> gameElements = [];
  double playerLeft = gameLogic.player.isLeft()
      ? ((widget.screenWidth - constants.TRUNK_WIDTH) / 4) -
          constants.PLAYER_WIDTH / 2
      : (3 * widget.screenWidth +
              constants.TRUNK_WIDTH -
              2 * constants.PLAYER_WIDTH) /
          4;
  Widget player = Positioned(
    bottom: constants.FLOOR_HEIGHT,
    left: playerLeft,
    child: Container(
      height: gameLogic.player.height,
      width: gameLogic.player.width,
      color: gameLogic.player.color,
    ),
  );
  for (int i = 0; i < gameLogic.obstacles.length; i++) {
    gameElements.add(Positioned(
      bottom: gameLogic.obstacles[i].bottom,
      left: gameLogic.obstacles[i].left,
      child: Container(
        height: gameLogic.obstacles[i].height,
        width: gameLogic.obstacles[i].width,
        color: gameLogic.obstacles[i].color,
      ),
    ));
  }
  gameElements.insert(0, player);
  return gameElements;
}
