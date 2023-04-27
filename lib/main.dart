import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/send_and_share.dart';
import 'package:sports_analyzer_sta/stats.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';


//We use getit to make singletons actually usable and clean in flutter
final getIt = GetIt.instance;

//////////////////////////////////////////
///These two classes are singletons are are STATIC and MUTABLE
///These have SHARED DATA and are N O T objects(in a oop sence)
///mkay future me
///SINGLTONES, NOT OBJECTS

class DataPoints extends ChangeNotifier{
  List<Point> _points = [];

  set points(List<Point> points){
    _points = points;
    notifyListeners();
  }

  List<Point> get points => _points;

}
class GlobalData extends ChangeNotifier{
  int _selectedPlayer = 0;

  set selectedPlayer(int player){
    _selectedPlayer = player;
    notifyListeners();
  }

  int get selectedPlayer => _selectedPlayer;

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
    DevicePreview(
      enabled: Platform.isLinux, //Disable on android and ios devices
      builder: (context) => const SportsAnalyzerSta(), // Wrap your app
    ),
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
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(title: 'Flames Sports Analyzer'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  int _selectedValue = 0;

  static final List<Widget> _HomeScreens = <Widget>[DataEntry(), Stats(),SendAndShare()];

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
            title: Text("Player Number"),
            content:StatefulBuilder(
                builder: (context, SBsetState) {
                  return NumberPicker(
                    value: _selectedValue,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                        GlobalDataInstance.selectedPlayer = _selectedValue;
                      });
                      SBsetState((){
                        _selectedValue = value;
                        GlobalDataInstance.selectedPlayer = _selectedValue;
                      });
                    },
                  );
                }
            ),

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
            BottomNavigationBarItem(
              icon: Icon(Icons.send_to_mobile),
              label: 'Send & Get' //TODO: put better text here
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            pickValue(context);
          },
          icon: const Icon(Icons.numbers),
          label: Text("$_selectedValue"),
        ));
  }
}
 