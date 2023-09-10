import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings / About"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Sports Analyzer")
          ],
      ),
    ));
  }
}
