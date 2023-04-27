//This file has all the source code for the "add data" section of the app
//i mean most, not all code

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/data_entry.dart';

import 'main.dart';

class Stats extends StatelessWidget with GetItMixin {
  // ignore: non_constant_identifier_names
  Widget chort_diagram(List<Point> playerPoints) {

    var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    return LayoutBuilder(builder: (context, constsains) {
      return Stack(
        children: [
          AspectRatio(
              aspectRatio: 9 / 16,
              child: Image.asset(
                "assets/basket_c.png",
                fit: BoxFit.scaleDown,
                color: chort,
                colorBlendMode: BlendMode.srcIn,
              )),
          ...playerPoints.map((point) {
            Color dot_colour = Colors.black;

            switch (point.type) {
              case DataPointType.Basket:
                dot_colour = Colors.green;
                break;
              case DataPointType.Foul:
                dot_colour = Colors.yellow;
                break;
              case DataPointType.Miss:
                dot_colour = Colors.red;
                break;
            }

            return Positioned(
              left: point.posx * constsains.maxWidth,
              top: point.posy * (constsains.maxWidth * (16/9)),
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: dot_colour,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //Points here are refering to datapoints

    final points = watchOnly((DataPoints dp) => dp.points);
    final player = watchOnly((GlobalData gd) => gd.selectedPlayer);

    final _playerPoints = points.where((i) => i.player == player).toList();

    final _totalPoints = _playerPoints.length;
    final _totalfouls = _playerPoints
        .where((p) => p.type == DataPointType.Foul)
        .length
        .toDouble();
    final _totalmiss = _playerPoints
        .where((p) => p.type == DataPointType.Miss)
        .length
        .toDouble();
    final _totalbasckets = _playerPoints
        .where((p) => p.type == DataPointType.Foul)
        .length
        .toDouble();

    if (_totalPoints < 12) {
      // 12 points give enought data to start building a model
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please add more data for player $player",
              style: const TextStyle(fontSize: 18),
            ),
            const CircularProgressIndicator()
          ],
        ),
      );
    }



    return Center(
      child: ListView(
        children: [
          //Data Showing what player it is
          Column(
            children: [
              Text(
                "Data for player: $player",
                style: const TextStyle(fontSize: 38),
              ),
              Divider()
            ],
          ),
          chort_diagram(_playerPoints),
          Placeholder(),
          Placeholder(),
          Placeholder()
        ],
      ),
    );
  }
}
