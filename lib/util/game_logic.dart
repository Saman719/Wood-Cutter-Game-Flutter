import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_game_wood_cutter/constants/game_constants.dart'
    as constants;

enum Position { RIGHT, LEFT }

class GameLogic {
  List<Obstacle> obstacles = [];
  late Player player;
  final screenHeight;
  final screenWidth;

  GameLogic({required this.screenWidth, required this.screenHeight}) {
    this.player = Player(position: Position.LEFT);
    var initCount = (((screenHeight -
                (constants.FLOOR_HEIGHT + constants.PLAYER_HEIGHT * 2)) /
        (constants.PLAYER_HEIGHT *
            2)) as double)
        .toInt();
    for (int i = 0; i < initCount; i++) {
      Position position =
          Random().nextBool() == true ? Position.LEFT : Position.RIGHT;
      double left = position == Position.LEFT
          ? 0
          : (screenWidth / 2) + (constants.TRUNK_WIDTH / 2);
      double bottom =
          (i + 1) * (2 * constants.PLAYER_HEIGHT) + constants.FLOOR_HEIGHT;
      obstacles.add(Obstacle(
          width: (screenWidth / 2) - (constants.TRUNK_WIDTH / 2),
          position: position,
          bottom: bottom,
          left: left));
    }
  }

  void nextMove(Position playerPosition) {
    player.position = playerPosition;
    obstacles.forEach((obstacle) {
      obstacle.bottom -= constants.PLAYER_HEIGHT;
    });
    obstacles
        .removeWhere((obstacle) => obstacle.bottom <= constants.FLOOR_HEIGHT);
    if (obstacles.last.bottom +
            (2 * constants.PLAYER_HEIGHT + constants.OBSTACLE_HEIGHT) <=
        screenHeight) {
      Position position =
          Random().nextBool() == true ? Position.LEFT : Position.RIGHT;
      double left = position == Position.LEFT
          ? 0
          : (screenWidth / 2) + (constants.TRUNK_WIDTH / 2);
      obstacles.add(Obstacle(
          width: (screenWidth / 2) - (constants.TRUNK_WIDTH / 2),
          position: position,
          bottom: obstacles.last.bottom + 2 * constants.PLAYER_HEIGHT,
          left: left));
    }
  }
}

class Player {
  final double height = constants.PLAYER_HEIGHT;
  final double width = constants.PLAYER_WIDTH;
  final Color color = Colors.red;
  Position position;

  bool isLeft() => position == Position.LEFT ? true : false;

  Player({required this.position});
}

class Obstacle {
  final double height = constants.OBSTACLE_HEIGHT;
  final double width;
  final Color color = Colors.brown;
  final Position position;
  double bottom;
  final double left;

  Obstacle(
      {required this.width,
      required this.position,
      required this.bottom,
      required this.left});
}
