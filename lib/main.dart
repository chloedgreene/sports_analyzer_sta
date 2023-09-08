
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/stats.dart';
import 'package:get_it/get_it.dart';

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

class DataPoints extends ChangeNotifier {
  List<Point> _points = [];

  set points(List<Point> points) {
    _points = points;
    notifyListeners(); // uses the GetIt function to notifi all child widgets to re-build
  }

  List<Point> get points => _points;
}

class GlobalData extends ChangeNotifier {
  int _selectedPlayer = 0;

  set selectedPlayer(int player) {
    _selectedPlayer = player;
    notifyListeners();
  }

  int get selectedPlayer => _selectedPlayer; //allows the selected player to remain the same cross-widget
}

//////////////////////////////////////////

void main() {
  GetIt.I.registerSingleton<DataPoints>(
    DataPoints(),
  );

  GetIt.I.registerSingleton<GlobalData>(
    GlobalData(),
  );

  runApp(
    const SportsAnalyzerSta(), // Wrap your app
  );
}

// DevicePreview(
// enabled: !kReleaseMode,
// builder: (context) => const SportsAnalyzerSta(), // Wrap your app
// ),

class SportsAnalyzerSta extends StatelessWidget {
  const SportsAnalyzerSta({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flames Sports Analyzer',
      theme: ThemeData(
        
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: flames_red,
          brightness: Brightness.light
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        //primarySwatch: Colors.red,
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: flames_red,
          brightness: Brightness.dark
          )
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(title: 'Flames Sports Analyzer'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, i cant prevent statful
  //i wish for stateless, but yk, l a z y
  // and it makes the coding so much easyer

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  int _selectedValue = 0;

  static final List<Widget> _HomeScreens = <Widget>[
    DataEntry(),
    Stats(),
  ];

  var GlobalDataInstance = GetIt.I.get<GlobalData>();

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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _HomeScreens.elementAt(_selectedIndex),
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
  }
}
