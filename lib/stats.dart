//This file has all the source code for the "add data" section of the app
//i mean most, not all code


import 'package:device_preview/device_preview.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'main.dart';

class Stats extends StatefulWidget{

  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();

}

class _StatsState extends State<Stats>{

  Widget placeholder_item(){
    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {

    var GlobalDataInstance = GetIt.I.get<GlobalData>();
    var DataPointsInstance = GetIt.I.get<DataPoints>();
    int player = GlobalDataInstance.selectedPlayer;

    return GridView.count(

      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,

      children: [
        Text(
            "Stat's for Player: $player",
            style: const TextStyle(fontSize: 32),
        ),
        SizedBox(
          height: 500,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.red,
                  value: 1/3,
                  title: 'Miss',
                ),
                PieChartSectionData(
                  color: Colors.yellow,
                  value: 1/3,
                  title: 'Foul',
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: 1/3,
                  title: 'Basket',
                )
              ]
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
            
          ),
        ),
        SizedBox(
          height: 500,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.red,
                  value: 1/3,
                  title: 'Miss',
                ),
                PieChartSectionData(
                  color: Colors.yellow,
                  value: 1/3,
                  title: 'Foul',
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: 1/3,
                  title: 'Basket',
                )
              ]
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
            
          ),
        ),
        SizedBox(
          height: 500,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.red,
                  value: 1/3,
                  title: 'Miss',
                ),
                PieChartSectionData(
                  color: Colors.yellow,
                  value: 1/3,
                  title: 'Foul',
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: 1/3,
                  title: 'Basket',
                )
              ]
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
            
          ),
        ),

        BarChart(
          BarChartData(
            
          ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        )

      ],
    );
  }

}