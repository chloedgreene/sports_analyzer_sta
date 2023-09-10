import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_analyzer_sta/main.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/data_entry.dart';

enum DataPointType { Basket, Foul, Miss }

class Point {
  double posx;
  double posy;
  DataPointType type; // Color of the point
  int player;

  Map<String, dynamic> toJson() => {
        'pos_x': posx,
        'pos_y': posy,
        'type': type.toString(),
        'player': player
      }; // move this into a json format, so it can easyer be send over network/local

  Point(this.posx, this.posy, this.type, this.player);

  /// this is fucking black magic, idk hwo it works
  /// i wrote it at 3 am
  /// pleace dont try to understand it
  /// it dosent make sence
  /// just
  /// god save your soul if you try to undersant this
  Point.fromJson(Map<String, dynamic> json)
      : posy = json['pos_y'],
        posx = json['pos_x'],
        type = DataPointType.values
            .byName(json['type'].toString().split('.').elementAt(1)),
        player = json['player'];
}

class DataEntry extends StatefulWidget with GetItStatefulWidgetMixin {
  DataEntry({super.key, required this.doc_id});

  final String doc_id;

  //const DataEntry({super.key});

  @override
  State<DataEntry> createState() => _DataEntryState(doc_id);
}

class _DataEntryState extends State<DataEntry> with GetItStateMixin {
  String doc_id = "";
  Key tap_key = Key("");


  List<bool> _selected = List.generate(3, (int index) {
    if (index == 1) {
      return true; //make the first option the default on
    }
    return false;
  });

  _DataEntryState(String this.doc_id);

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

    int playerNumber = watchOnly((GlobalData gd) => gd.selectedPlayer);

    //print(doc_id);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("games")
            .doc(doc_id)
            .snapshots(),
        builder: (builder, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          Map<String, dynamic> docdata =
              snapshot.data!.data() as Map<String, dynamic>;

          return Center(
              child: ListView(children: [
            LayoutBuilder(builder: (context, constraigns) {
              double width = constraigns.maxWidth;
              double height = constraigns.maxHeight;

              return Stack(
                children: [
                  GestureDetector(
                    key: tap_key,
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        // do some weird tom fuckery to get the height from the width(aspect ratio math bs)

                        final imageSize = context.size;

                        // Calculate the normalized position
                        final normalizedPosition = Offset(
                          details.localPosition.dx / imageSize!.width,
                          details.localPosition.dy / imageSize!.height,
                        );
        


                        print(normalizedPosition.dx);
                        print(.dy);


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

                        var point = (Point(position.dx, position.dy,
                            pointType, playerNumber));

                        FirebaseFirestore.instance
                            .collection("games")
                            .doc(doc_id)
                            .update({
                          "points": FieldValue.arrayUnion([jsonEncode(point)])
                        });
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
                  ...docdata["points"].map((prepoint) {
                    //grwy out points and make then small

                    //print(prepoint);

                    Point point = Point.fromJson(jsonDecode(prepoint));

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
        });
  }
}
