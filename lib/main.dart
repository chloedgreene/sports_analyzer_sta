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
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/game_page.dart';
import 'package:sports_analyzer_sta/stats.dart';
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

class DataPoints extends ChangeNotifier {
  List<List<Point>> _points = [ [] ];
  int _selectedGame = 0;
  int _game_count = 1;

  set points(List<Point> points) {
    _points[_selectedGame] = points;
    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  set currentGame(int index) {
    _selectedGame = index;
    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  set currentGameCount(int index) {
    _game_count = index;
    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  List<Point> get points => _points[_selectedGame];
  int get currentGame => _selectedGame;
  int get gameCount => _game_count;
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
          title: Text("Game select"),
        ),
        body: Center(
            child: ListView.builder(
                itemCount: DataPointsInstance._game_count,
                itemBuilder: (bc, i) {
                  if (i == 5) {
                    return null;
                  }

                  return Card(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return GamePage(title: "Example game");
                      }));
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Semi-Finals"),
                          subtitle: Text("Thris is just a example game"),
                        )
                      ],
                    ),
                  ));
                })),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.numbers),
          label: const Text("Dosent exsist yet"),
          backgroundColor: flames_red,
        ));
  }
}
