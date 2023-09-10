//HEYYYYYYYYY mr mac i just gotta tell you something
//Ok so, how do i say this, im trans
//so if you see any code attributed to chloe
//i a m chloe
//i hope this dispells confusion
//id also like if you dont relly call me "he" like, at all,
//thank you so much for understandingggggg
//actual code below :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
//import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/main.dart';
import 'package:sports_analyzer_sta/stats.dart';
//import 'package:sports_analyzer_sta/stats.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.doc_id});

  // This widget is the home page of your application. It is stateful, i cant prevent statful
  //i wish for stateless, but yk, l a z y
  // and it makes the coding so much easyer

  final String doc_id;

  @override
  State<GamePage> createState() => _GamePageState(doc_id);
}

class _GamePageState extends State<GamePage> {
  String doc_id = "";
  int _selectedIndex = 0;

  int _selectedValue = 0;

  var GlobalDataInstance = GetIt.I.get<GlobalData>();

  _GamePageState(String this.doc_id);

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  void pickValue(BuildContext context) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Player Number"),
            content: StatefulBuilder(builder: (context, SBsetState) {
              return NumberPicker(
                value: _selectedValue,
                minValue: 0,
                maxValue: 99,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                    GlobalDataInstance.selectedPlayer = _selectedValue;
                  });
                  SBsetState(() {
                    _selectedValue = value;
                    GlobalDataInstance.selectedPlayer = _selectedValue;
                  });
                },
              );
            }),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  setState(() {
                    GlobalDataInstance.selectedPlayer = _selectedValue;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          Map<String, dynamic> docdata =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
              appBar: AppBar(
                title: Text(docdata["title"]),
              ),
              body: Builder(builder: (bc) {
                if (_selectedIndex == 0) {
                  return DataEntry(doc_id: doc_id);
                }
                if (_selectedIndex == 1) {
                  return Stats(doc_id: doc_id,);
                }



                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Add Data',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.graphic_eq),
                    label: 'Stats',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: flames_red,
                onTap: _onItemTapped,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  pickValue(context);
                },
                icon: const Icon(Icons.numbers),
                label: Text("$_selectedValue"),
                backgroundColor: flames_red,
              ));
        });
  }
}
