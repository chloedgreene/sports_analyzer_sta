//This file has all the source code for the "add data" section of the app
//i mean most, not all code

//import 'dart:math';

//import 'package:device_preview/device_preview.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_analyzer_sta/main.dart';

class Point {
  double posx;
  double posy;
  Color color; // Color of the point
  int player;

  Point(this.posx,this.posy, this.color,this.player);
}

class DataEntry extends StatefulWidget {
  const DataEntry({super.key});

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  List<bool> _selected = List.generate(3, (int index) {
    if (index == 1){
      return true;
    }
    return false;
  });

  @override
  Widget build(BuildContext context) {

    //_selected[0] = true;
    //Set colour of the chort to be dynamic to phone themeing
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    var GlobalDataInstance = GetIt.I.get<GlobalData>();
    var DataPointsInstance = GetIt.I.get<DataPoints>();

    int player_number = GlobalDataInstance.selectedPlayer;
    //Add points to a list so they can be drawn
    return Center(
        child: ListView(children: [
      LayoutBuilder(builder: (context,constraigns){

        double width = constraigns.maxWidth;
        print(width);


        return Stack(
        children: [
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              setState(() {

                

                // do some weird tom fuckery to get the height from the width(aspect ratio math bs)
                                
                var pos = Offset(details.localPosition.dx / width, details.localPosition.dy);
              
                var relitaveposx = details.localPosition.dx / width;
                var relitaveposy = details.localPosition.dy;

                Color point_color = Colors.black;

                //Score Count up
                if (_selected.elementAt(0)) {
                  point_color = Colors.green;
                }

                //Pass
                if (_selected.elementAt(1)) {
                  point_color = Colors.yellow;
                }

                //Miss
                if (_selected.elementAt(2)) {
                  point_color = Colors.red;
                }

                DataPointsInstance.points.add(Point(relitaveposx,relitaveposy, point_color,player_number));
              });
            },
            child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.asset(
                  "assets/basket_c.png",
                  fit: BoxFit.scaleDown,
                )
                ),
          ),
          ...DataPointsInstance.points.map((point) {

            //grwy out points and make then small
            if (point.player != player_number){
              var x = point.player;              
              
                return Positioned(
                left: point.posx * width,
                top: point.posy,
                child: Tooltip(

                  message: "Player $x",
                  child: Container(
                  width:  10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(127, 158, 158, 158),
                    shape: BoxShape.circle,
                   

                  ),
                ),
                )
              );
            }

            return Positioned(
                left: point.posx * width,
                top: point.posy,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: point.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
          }),
        ],
      );

      }),
      Center(
        child: ToggleButtons(
            isSelected: _selected,
            onPressed: (int index) {
              setState(() {
                //make it so only 1 option can be set
                _selected = List.generate(3, (_) => false);
                _selected[index] = !_selected[index];
              });
            },
            children: const [
              Text("Basket"), //TODO: ask mr.mac for basic sports info
              Text("Foul"),
              Text("Miss")
            ]),
      )
    ]));
  }
}
