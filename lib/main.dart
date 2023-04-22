import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:sports_analyzer_sta/stats.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
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

  static const List<Widget> _HomeScreens = <Widget>[DataEntry(), Stats()];

  void pickValue() {

    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Get Player Number"),
            content:StatefulBuilder(
                builder: (context, SBsetState) {
                  return NumberPicker(
                    value: _selectedValue,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                      SBsetState((){
                        _selectedValue = value;
                      });
                    },
                  );
                }
            ),

            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
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
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            pickValue();
          },
          icon: const Icon(Icons.numbers),
          label: Text("$_selectedValue"),
        ));
  }
}
