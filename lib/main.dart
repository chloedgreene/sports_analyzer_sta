//HEYYYYYYYYY mr mac i just gotta tell you something
//Ok so, how do i say this, im trans
//so if you see any code attributed to chloe
//i a m chloe
//i hope this dispells confusion
//id also like if you dont relly call me "he" like, at all,
//thank you so much for understandingggggg
//actual code below :

import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_analyzer_sta/GameConbiner.dart';
import 'package:sports_analyzer_sta/cross_country.dart';
import 'package:sports_analyzer_sta/game_page.dart';
import 'package:intl/intl.dart';

import 'firebase_options.dart';

//We use getit to make singletons actually usable and clean in flutter
final getIt = GetIt.instance;

const flames_red = Color(0xffd9232a);

///////////////////////////////////////////////////////////////
///These two classes are singletons are are STATIC and MUTABLE
///These have SHARED DATA and are N O T objects(in a oop sence)
///mkay future me
///SINGLTONES, NOT OBJECTS
///AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHh
///Y O U N E E D T O R E M E M B E R
///singletons are d i f f e r e n t
///i am so sorry for ranting anybody seeing this code
///you jut need to r e m e m b e r
///mkay
///
class GlobalData extends ChangeNotifier {
  int _selectedPlayer = 0;
  String current_game = "";

  set selectedPlayer(int player) {
    _selectedPlayer = player;
    notifyListeners();
  }

  set selectedGame(String player) {
    current_game = player;
    notifyListeners();
  }

  int get selectedPlayer =>
      _selectedPlayer; //allows the selected player to remain the same cross-widget
  String get selectedGame =>
      current_game; //allows the selected player to remain the same cross-widget
}

//////////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<GlobalData>(
    GlobalData(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    SportsAnalyzerSta(), // Wrap your app
  );
}

// DevicePreview(
// enabled: !kReleaseMode,
// builder: (context) => const SportsAnalyzerSta(), // Wrap your app
// ),

class SportsAnalyzerSta extends StatelessWidget with GetItMixin {
  SportsAnalyzerSta({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flames Sports Analyzer',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
            seedColor: flames_red, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          //primarySwatch: Colors.red,
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: flames_red, brightness: Brightness.dark)),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget with GetItStatefulWidgetMixin {
  HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var GlobalDataInstance = GetIt.I.get<GlobalData>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _conbineKey = GlobalKey<FormState>();

  //this is the temp varublas to store the title and subtitle for the new g a m ez
  String title = "";
  String subtitle = "";

  bool newgame_is_girls = false;
  bool newgame_is_home = false;
  bool newgame_is_jr = false;
  int newgame_session_year = 2000;

  void reset_form_values() {
    //Just reset back to defaults
    newgame_is_girls = false;
    newgame_is_home = false;
    newgame_is_jr = false;
    newgame_session_year = 2000;
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('games').snapshots();

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Game select"),
          actions: [
            IconButton(
              icon: const Icon(Icons.compress),
              tooltip: 'Conbine Games Together',
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return GameConbiner();
                // }));
                reset_form_values();
                showDialog(
                    context: context,
                    builder: (bc) {
                      return Dialog.fullscreen(
                        child: Scaffold(
                            appBar: AppBar(
                              title: const Text("New Game Report"),
                            ),
                            body: Form(
                                key: _conbineKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        "Select Querys to turn into a game report"),
                                    CheckboxListTileFormField(
                                      title: const Text("Is Girls Game?"),
                                      onSaved: (bool? newValue) {
                                        newgame_is_girls = newValue!;
                                      },
                                      onChanged: (bool? value) {
                                        newgame_is_girls = value!;
                                      },
                                    ),
                                    CheckboxListTileFormField(
                                      title: const Text("Is Junior Game?"),
                                      onSaved: (bool? newValue) {
                                        newgame_is_jr = newValue!;
                                      },
                                      onChanged: (bool? value) {
                                        newgame_is_jr = value!;
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Starting Year of the Season, For example for 2023-2024, write 2023',
                                      ),
                                      validator: (String? value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            (int.tryParse(value) ?? 0) <= 0) {
                                          return 'Please enter a year';
                                        }
                                        return null;
                                      },
                                      onSaved: (v) {
                                        newgame_session_year = int.parse(v!);
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Validate will return true if the form is valid, or false if
                                          // the form is invalid.
                                          if (_conbineKey.currentState!
                                              .validate()) {
                                            _conbineKey.currentState?.save();

                                            var query = db
                                                .collection("games")
                                                .where("is_girls",
                                                    isEqualTo: newgame_is_girls)
                                                .where("is_jr",
                                                    isEqualTo: newgame_is_jr)
                                                .get()
                                                .then(
                                              (querySnapshot) {
                                                print(
                                                    "Successfully Got Query, Lets Get the points and merge");

                                                var reports_points =
                                                    [].toList();

                                                for (var docSnapshot
                                                    in querySnapshot.docs) {
                                                  var local_points = docSnapshot
                                                      .data()["points"];

                                                  for (var points
                                                      in local_points) {
                                                    reports_points.add(points);
                                                  }
                                                }

                                                final DateTime now = DateTime.now();
                                                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                                final String formatted = formatter.format(now);

                                                final user = <String, dynamic>{
                                                  "title": "Game Report",
                                                  "subtitle": "Created on $formatted",
                                                  "points": reports_points,
                                                  "is_girls": newgame_is_girls,
                                                  "is_home": newgame_is_home,
                                                  "is_jr": newgame_is_jr,
                                                  "sesion_year": newgame_session_year
                                                };

                                                db.collection("games").add(user).then(
                                                    (DocumentReference doc) => print(
                                                        'DocumentSnapshot added with ID: ${doc.id}'));

                                                print(reports_points);
                                              },
                                              onError: (e) =>
                                                  print("Error completing: $e"),
                                            );
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: const Text('Make Game Report'),
                                      ),
                                    ),
                                  ],
                                ))),
                      );
                    });
              },
            ),
            IconButton(
              icon: const Icon(Icons.directions_run),
              tooltip: 'Cross Country',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const CrossCountry();
                }));
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (ctx, snapcshots) {
                if (snapcshots.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapcshots.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapcshots.data!.docs.isEmpty) {
                  return const Text(
                      "No games found, please add one"); // wow i found so formal -_-
                }

                return ListView(
                  children: snapcshots.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        // return ListTile(
                        //   title: Text(data['title']),
                        //   subtitle: Text(data['subtitle']),
                        // );

                        bool is_girls_game = data["is_girls"];
                        bool is_home_game = data["is_home"];
                        bool is_junior_game = data["is_jr"];
                        int year_game = data["sesion_year"];
                        int next_year = year_game + 1; // just a temp varuable

                        return Card(
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    GlobalDataInstance.current_game =
                                        document.id;
                                    return GamePage(
                                      doc_id: document.id,
                                    );
                                  }));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(data['title']),
                                        subtitle: Text(data['subtitle']),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Chip(
                                            label: Text(
                                                is_girls_game
                                                    ? 'Girls'
                                                    : 'Boys',
                                                style: const TextStyle(
                                                    fontSize: 12.0))),
                                        Chip(
                                            label: Text(
                                                is_home_game ? 'Home' : 'Away',
                                                style: const TextStyle(
                                                    fontSize: 12.0))),
                                        Chip(
                                            label: Text(
                                                is_junior_game
                                                    ? 'Junior'
                                                    : 'Senior',
                                                style: const TextStyle(
                                                    fontSize: 12.0))),
                                        Chip(
                                            label: Text("$year_game-$next_year",
                                                style: const TextStyle(
                                                    fontSize: 12.0)))
                                      ],
                                    ))
                                  ],
                                )));
                      })
                      .toList()
                      .cast(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            reset_form_values();
            showDialog(
                context: context,
                builder: (bc) {
                  return Dialog.fullscreen(
                    child: Scaffold(
                        appBar: AppBar(
                          title: const Text("New Game"),
                        ),
                        body: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Game Title',
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please a title';
                                    }
                                    return null;
                                  },
                                  onSaved: (v) {
                                    title = v!;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Game SubTitle',
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please a subtitle';
                                    }
                                    return null;
                                  },
                                  onSaved: (v) {
                                    subtitle = v!;
                                  },
                                ),
                                CheckboxListTileFormField(
                                  title: const Text("Is Girls Game?"),
                                  onSaved: (bool? newValue) {
                                    newgame_is_girls = newValue!;
                                  },
                                  onChanged: (bool? value) {
                                    newgame_is_girls = value!;
                                  },
                                ),
                                CheckboxListTileFormField(
                                  title: const Text("Is Junior Game?"),
                                  onSaved: (bool? newValue) {
                                    newgame_is_jr = newValue!;
                                  },
                                  onChanged: (bool? value) {
                                    newgame_is_jr = value!;
                                  },
                                ),
                                CheckboxListTileFormField(
                                  title: const Text("Is Home Game?"),
                                  onSaved: (bool? newValue) {
                                    newgame_is_home = newValue!;
                                  },
                                  onChanged: (bool? value) {
                                    newgame_is_home = value!;
                                  },
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Starting Year of the Season, For example for 2023-2024, write 2023',
                                  ),
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        (int.tryParse(value) ?? 0) <= 0) {
                                      return 'Please enter a year';
                                    }
                                    return null;
                                  },
                                  onSaved: (v) {
                                    newgame_session_year = int.parse(v!);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Validate will return true if the form is valid, or false if
                                      // the form is invalid.
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState?.save();

                                        final user = <String, dynamic>{
                                          "title": title,
                                          "subtitle": subtitle,
                                          "points": [],
                                          "is_girls": newgame_is_girls,
                                          "is_home": newgame_is_home,
                                          "is_jr": newgame_is_jr,
                                          "sesion_year": newgame_session_year
                                        };

                                        db.collection("games").add(user).then(
                                            (DocumentReference doc) => print(
                                                'DocumentSnapshot added with ID: ${doc.id}'));

                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ],
                            ))),
                  );
                });
          },
          icon: const Icon(Icons.numbers),
          label: const Text("Add Game"),
          backgroundColor: flames_red,
        ));
  }
}
