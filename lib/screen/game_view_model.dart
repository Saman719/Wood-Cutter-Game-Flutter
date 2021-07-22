import 'package:flutter/material.dart';
import 'package:flutter_app_game_wood_cutter/constants/game_constants.dart'
    as constants;
import 'package:flutter_app_game_wood_cutter/util/game_logic.dart';

class GameViewModel extends StatefulWidget {
  late final double screenWidth;
  late final double screenHeight;
  late final GameLogic gameLogic;

  GameViewModel({required this.screenWidth, required this.screenHeight}) {
    this.gameLogic =
        GameLogic(screenWidth: screenWidth, screenHeight: screenHeight);
  }

  @override
  _GameViewModelState createState() => _GameViewModelState();
}

class _GameViewModelState extends State<GameViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (detail) {
          print(detail.kind);
          setState(() {
            detail.globalPosition.dx > (widget.screenWidth / 2)
                ? widget.gameLogic.nextMove(Position.RIGHT)
                : widget.gameLogic.nextMove(Position.LEFT);
          });
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
