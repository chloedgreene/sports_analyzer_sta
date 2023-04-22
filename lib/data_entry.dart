//This file has all the source code for the "add data" section of the app
//i mean most, not all code

import 'dart:math';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';

class Point {
  Offset position; // Position of the point
  Color color; // Color of the point

  Point(this.position, this.color);
}

class DataEntry extends StatefulWidget {
  const DataEntry({super.key});

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  List<Point> points = [];
  List<bool> _selected = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    //Set colour of the chort to be dynamic to phone themeing
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    //Add points to a list so they can be drawn
    return Center(
        child: ListView(children: [
      Stack(
        children: [
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              setState(() {

                Color point_color = Colors.black;

                //Score Count up
                if (_selected.elementAt(0)){
                  point_color = Colors.green;
                }

                //Pass
                if (_selected.elementAt(1)){
                  point_color = Colors.yellow;
                }

                //Miss
                if (_selected.elementAt(2)){
                  point_color = Colors.red;
                }

                points.add(Point(details.localPosition, point_color));
              });
            },
              child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Image.asset(
                    "assets/basket_c.png",
                    height: 30,
                  )),
            ),
          ...points.map((point) => Positioned(
                left: point.position.dx,
                top: point.position.dy,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: point.color,
                    shape: BoxShape.circle,
                  ),
                ),
              )),
        ],
      ),
      ToggleButtons(
          isSelected: _selected,
          onPressed: (int index) {
            setState(() {
              //make it so only 1 option can be set
              _selected = List.generate(3, (_) => false);
              _selected[index] = !_selected[index];
            });
          },
          children: const [
            const Text("Good"),
            const Text("Pass"),
            const Text("Miss")
          ])
    ]));
  }
}
