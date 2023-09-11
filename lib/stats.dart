import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/main.dart';
import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:sports_analyzer_sta/data_entry.dart';

class Stats extends StatefulWidget with GetItStatefulWidgetMixin {
  Stats({super.key, required this.doc_id});

  final String doc_id;

  //const DataEntry({super.key});

  @override
  State<Stats> createState() => _StatsState(doc_id);
}

class _StatsState extends State<Stats> with GetItStateMixin {
  String doc_id = "";
  bool _use_per_player = false;

  _StatsState(String this.doc_id);

  @override
  Widget build(BuildContext context) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    final player = watchOnly((GlobalData gd) => gd.selectedPlayer);

    return Center(
      child: Column(
        children: [
          SegmentedButton(
              segments: const [
                ButtonSegment<bool>(
                    value: false,
                    label: Text("Game Stats"),
                    icon: Icon(Icons.sports_basketball)),
                ButtonSegment<bool>(
                    value: true,
                    label: Text("Per-Player Stats"),
                    icon: Icon(Icons.directions_run))
              ],
              selected: <bool>{
                _use_per_player
              },
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  _use_per_player = newSelection.first;
                });
              }),
          Divider(),
          Expanded(
            child: Column(children: [
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("games")
                          .doc(doc_id)
                          .snapshots(),
                      builder: (builder, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        Map<String, dynamic> docdata =
                            snapshot.data!.data() as Map<String, dynamic>;

                        List<Point> raw_data = [];

                        (docdata["points"] as List<dynamic>).forEach((value) {
                          Point p = Point.fromJson(jsonDecode(value));
                          if (_use_per_player) {
                            if (p.player == player) {
                              raw_data.add(p);
                            }
                          } else {
                            raw_data.add(p);
                          }
                        });

                        //precomcupted stats

                        return LayoutBuilder(builder: (context, constraigns) {
                          double width = constraigns.maxWidth;
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
                              ...raw_data.map((point) {
                                //grwy out points and make then small

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
                        });
                      }))
            ]),
          )
        ],
      ),
    );
  }
}
