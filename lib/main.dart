//HEYYYYYYYYY mr mac i just gotta tell you something
//Ok so, how do i say this, im trans
//so if you see any code attributed to chloe
//i a m chloe
//i hope this dispells confusion
//id also like if you dont relly call me "he" like, at all,
//thank you so much for understandingggggg
//actual code below :

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/game_page.dart';
import 'package:get_it/get_it.dart';

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

class Game {
  String title = "";
  String subtitle = "";
  int id = 0;
  List<Point> points = [];

  Game(String ttitle, String ssubtitle) {
    title = ttitle;
    subtitle = ssubtitle;
  }
}

class DataPoints extends ChangeNotifier {
  final List<Game> _points = [];
  int _selectedGame = 0;

  set points(List<Point> points) {
    _points[_selectedGame].points = points;
    //var db = FirebaseFirestore.instance;

    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  set currentGame(int index) {
    _selectedGame = index;
    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  int get_length() {
    return _points.length;
  }

  List<Point> get points => _points[_selectedGame].points;
  int get currentGame => _selectedGame;
  Game get selectedGame => _points[_selectedGame];
}

class GlobalData extends ChangeNotifier {
  int _selectedPlayer = 0;

  set selectedPlayer(int player) {
    _selectedPlayer = player;
    notifyListeners();
  }

  int get selectedPlayer =>
      _selectedPlayer; //allows the selected player to remain the same cross-widget
}

//////////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<DataPoints>(
    DataPoints(),
  );

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
  String title = "";
  String subtitle = "";

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    var DataPointsInstance = GetIt.I.get<DataPoints>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Game select"),
        ),
        body: Center(
          child: Builder(builder: (ctx) {
            if (DataPointsInstance.get_length() == 0) {
              return const Text(
                  "No games found, please add one"); // wow i found so formal -_-
            }

            return ListView.builder(
                itemCount: DataPointsInstance.get_length(),
                itemBuilder: (bc, i) {
                  DataPointsInstance.currentGame = i;
                  return Card(
                      child: InkWell(
                    onTap: () {
                      DataPointsInstance.currentGame = i;
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return GamePage(title: DataPointsInstance.selectedGame.title);
                      }));
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(DataPointsInstance.selectedGame.title),
                          subtitle:
                              Text(DataPointsInstance.selectedGame.subtitle),
                        )
                      ],
                    ),
                  ));
                });
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

                                        setState(() {
                                          DataPointsInstance._points
                                              .add(Game(title, subtitle));
                                          DataPointsInstance.notifyListeners();
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
