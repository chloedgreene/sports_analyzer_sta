//This file has all the source code for the "add data" section of the app
//i mean most, not all code

//import 'dart:math';

//import 'package:device_preview/device_preview.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/main.dart';

enum DataPointType { Basket, Foul, Miss }

class Point {
  double posx;
  double posy;
  DataPointType type; // Color of the point
  int player;

  Map<String, dynamic> toJson() =>
      {'pos_x': posx, 'pos_y': posy, 'type': type.toString(), 'player': player};

  Point(this.posx, this.posy, this.type, this.player);

  Point.fromJson(Map<String, dynamic> json)
      : posy = json['pos_y'],
        posx = json['pos_x'],
        type = DataPointType.values
            .byName(json['type'].toString().split('.').elementAt(1)),
        player = json['player'];
}

class DataEntry extends StatefulWidget with GetItStatefulWidgetMixin {
  DataEntry({super.key});

  //const DataEntry({super.key});

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> with GetItStateMixin {
  List<bool> _selected = List.generate(3, (int index) {
    if (index == 1) {
      return true; //make the first option the default on
    }
    return false;
  });

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

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

    int playerNumber = watchOnly((GlobalData gd) => gd.selectedPlayer);
    //Add points to a list so they can be drawn
    return Center(
        child: ListView(children: [
      LayoutBuilder(builder: (context, constraigns) {
        double width = constraigns.maxWidth;

        return Stack(
          children: [
            GestureDetector(
              onTapUp: (TapUpDetails details) {
                setState(() {
                  // do some weird tom fuckery to get the height from the width(aspect ratio math bs)

                  var pos = Offset(details.localPosition.dx / width,
                      details.localPosition.dy);

                  var relitaveposx = details.localPosition.dx / width;
                  var relitaveposy =
                      details.localPosition.dy / (width * (16 / 9));

                  //print(relitaveposy);

                  DataPointType pointType = DataPointType.Miss;

                  //Score Count up
                  if (_selected.elementAt(0)) {
                    pointType = DataPointType.Basket;
                  }

                  //Pass
                  if (_selected.elementAt(1)) {
                    pointType = DataPointType.Foul;
                  }

                  //Miss
                  if (_selected.elementAt(2)) {
                    pointType = DataPointType.Miss;
                  }

                  DataPointsInstance.points.add(Point(
                      relitaveposx, relitaveposy, pointType, playerNumber));
                });
              },
              child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Image.asset(
                    "assets/basket_c.png",
                    fit: BoxFit.scaleDown,
                    color: chort,
                    colorBlendMode: BlendMode.srcIn,
                  )),
            ),
            ...DataPointsInstance.points.map((point) {
              //grwy out points and make then small
              if (point.player != playerNumber) {
                var x = point.player;

                return Positioned(
                    left: point.posx * width,
                    top: point.posy * (width * (16 / 9)),
                    child: Tooltip(
                      message: "Player $x",
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(127, 158, 158, 158),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ));
              }

              Color dotColour = Colors.black;

              switch (point.type) {
                case DataPointType.Basket:
                  dotColour = Colors.green;
                  break;
                case DataPointType.Foul:
                  dotColour = Colors.yellow;
                  break;
                case DataPointType.Miss:
                  dotColour = Colors.red;
                  break;
              }

              return Positioned(
                left: point.posx * width,
                top: point.posy * (width * (16 / 9)),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: dotColour,
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
