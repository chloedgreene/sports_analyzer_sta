//HEYYYYYYYYY mr mac i just gotta tell you something
//Ok so, how do i say this, im trans
//so if you see any code attributed to chloe
//i a m chloe
//i hope this dispells confusion
//id also like if you dont relly call me "he" like, at all,
//thank you so much for understandingggggg
//actual code below :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_analyzer_sta/about.dart';
import 'package:sports_analyzer_sta/cross_country.dart';
import 'package:sports_analyzer_sta/game_page.dart';

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

  //this is the temp varublas to store the title and subtitle for the new g a m ez
  String title = "";
  String subtitle = "";

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
              icon: const Icon(Icons.settings),
              tooltip: 'Show settings/About page',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return About();
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.directions_run),
              tooltip: 'Cross Country',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CrossCountry();
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
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(data['title']),
                                      subtitle: Text(data['subtitle']),
                                    )
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
                                          "points": []
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
