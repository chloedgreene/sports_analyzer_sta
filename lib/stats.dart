//This file has all the source code for the "add data" section of the app
//i mean most, not all code


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/data_entry.dart';

import 'main.dart';

class Stats extends StatelessWidget with GetItMixin{


  @override
  Widget build(BuildContext context) {

    //Points here are refering to datapoints

    final points = watchOnly((DataPoints dp) => dp.points         );
    final player = watchOnly((GlobalData gd) => gd.selectedPlayer );

    final _playerPoints = points.where((i) => i.player == player).toList();

    final _totalPoints = points.where((i) => i.player == player).toList();
    final _totalfouls    = _playerPoints.where((p) => p.type == DataPointType.Foul).length;
    final _totalmiss     = _playerPoints.where((p) => p.type == DataPointType.Miss).length;
    final _totalbasckets = _playerPoints.where((p) => p.type == DataPointType.Foul).length;


    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Text(
            "Data for player: $player",
            style: const TextStyle(
              fontSize: 38
            ),
            ),
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.amber,
                  value: 100.0 - player 
                ),
                
              ]
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
          Placeholder(),
          Placeholder(),
          Placeholder(),
          Placeholder()
        ],
      ),
    );


  }

}