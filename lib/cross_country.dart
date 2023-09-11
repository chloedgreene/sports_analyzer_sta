

//All code is made by MRMAC
//https://github.com/MrMacLdn/raceday

import 'package:flutter/material.dart';

class CrossCountry extends StatefulWidget {
  const CrossCountry({super.key});

  @override
  State<CrossCountry> createState() => _CrossCountryState();
}

class _CrossCountryState extends State<CrossCountry> {
  //Intial Variables
  List<int> runners1 = [0, 0, 0, 0, 0];
  List<int> runners2 = [0, 0, 0, 0, 0];
  List<int> runners3 = [0, 0, 0, 0, 0];

  int tm1 = 0;
  int tm2 = 0;
  int tm3 = 0;

  int total1 = 0;
  int total2 = 0;
  int total3 = 0;

  int total12 = 0;
  int total22 = 0;
  int total32 = 0;

  int lap = 1;
  int lap12dif = 0; //difference in score between sta and team 2 lap 1
  int lap13dif = 0; //difference in score between sta and team 3 lap 1
  int lap22dif = 0; //difference in score between sta and team 2 lap 2
  int lap23dif = 0; //difference in score between sta and team 3 lap 2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Raceday",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      //Body Begins for each team counter
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '   STA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm1 == 0
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners1[0].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm1 == 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners1[1].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm1 == 2
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners1[2].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm1 == 3
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners1[3].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm1 == 4
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners1[4].toString()),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (tm1 < 5) {
                        tm1++;
                      }
                    });
                  },
                  child: Icon(Icons.run_circle_outlined),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),

          // Start of Team 2 runner collection
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Team 2',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm2 == 0
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners2[0].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm2 == 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners2[1].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm2 == 2
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners2[2].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm2 == 3
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners2[3].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm2 == 4
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners2[4].toString()),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (tm2 < 5) {
                        tm2++;
                      }
                    });
                  },
                  child: Icon(Icons.run_circle_outlined),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),

          // Start of Team 3 runner collection
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Team 3',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm3 == 0
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners3[0].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm3 == 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners3[1].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm3 == 2
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners3[2].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm3 == 3
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners3[3].toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: tm3 == 4
                        ? Colors.red
                        : Theme.of(context).colorScheme.background,
                  ),
                  child: Text(runners3[4].toString()),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (tm3 < 5) {
                        tm3++;
                      }
                    });
                  },
                  child: Icon(Icons.run_circle_outlined),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),

          // Start of Lap 1 Team totals
          Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Lap 1',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'STA - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total1",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Team 2 - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total2",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Team 3 - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total3",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ' - ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        lap12dif > 0 ? '+' + '$lap12dif' : '$lap12dif',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        lap13dif > 0 ? '+' + '$lap13dif' : '$lap13dif',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),

          // Start of Lap 2 Team totals
          Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Lap 2',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'STA - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total12",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Team 2 - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total22",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Team 3 - ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$total32",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ' - ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        lap22dif > 0 ? '+' + '$lap22dif' : '$lap22dif',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        lap23dif > 0 ? '+' + '$lap23dif' : '$lap23dif',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Final buttons starting with moving to lap 2
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      lap = 2;
                      runners1 = [0, 0, 0, 0, 0];
                      runners2 = [0, 0, 0, 0, 0];
                      runners3 = [0, 0, 0, 0, 0];

                      tm1 = 0;
                      tm2 = 0;
                      tm3 = 0;
                    });
                  },
                  child: const Text("Lap 2"),
                ),

                // Main runner increase button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var i = tm1; i < runners1.length; i++) {
                        runners1[i]++;
                      }

                      for (var i = tm2; i < runners2.length; i++) {
                        runners2[i]++;
                      }

                      for (var i = tm3; i < runners3.length; i++) {
                        runners3[i]++;
                      }

                      if (lap == 1) {
                        total1 =
                            runners1.fold(0, (p, e) => p + e) - runners1[4];
                        total2 =
                            runners2.fold(0, (p, e) => p + e) - runners2[4];
                        total3 =
                            runners3.fold(0, (p, e) => p + e) - runners3[4];
                        lap12dif = total1 - total2;
                        lap13dif = total1 - total3;
                      } else {
                        total12 =
                            runners1.fold(0, (p, e) => p + e) - runners1[4];
                        total22 =
                            runners2.fold(0, (p, e) => p + e) - runners2[4];
                        total32 =
                            runners3.fold(0, (p, e) => p + e) - runners3[4];
                        lap22dif = total12 - total22;
                        lap23dif = total12 - total32;
                      }
                    });
                  },
                  child: const Text("Runner"),
                ),

                // Clear button to reset all values
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      runners1 = [0, 0, 0, 0, 0];
                      runners2 = [0, 0, 0, 0, 0];
                      runners3 = [0, 0, 0, 0, 0];

                      tm1 = 0;
                      tm2 = 0;
                      tm3 = 0;

                      total1 = 0;
                      total2 = 0;
                      total3 = 0;

                      total12 = 0;
                      total22 = 0;
                      total32 = 0;

                      lap = 1;

                      lap12dif =
                          0; //difference in score between sta and team 2 lap 1
                      lap13dif =
                          0; //difference in score between sta and team 3 lap 1
                      lap22dif =
                          0; //difference in score between sta and team 2 lap 2
                      lap23dif = 0;
                    });
                  },
                  child: const Text("Clear"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
