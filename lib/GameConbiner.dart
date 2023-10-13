// import 'package:flutter/material.dart';

// class GameConbiner extends StatefulWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title:  const Text("Compile Games Report"),
//       ),
//       body: const Center(
//         child: Column(
//           children: [
//             Placeholder()
//           ],
//       ),
//     ));
//   }
// }


import 'package:flutter/material.dart';

class GameConbiner extends StatefulWidget {

  const GameConbiner({ super.key });

  @override
  State<GameConbiner> createState() => _GameConbinerState();

}


class _GameConbinerState extends State<GameConbiner> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title:  const Text("Compile Games Report"),
       ),
       body: const Center(
         child: Column(
           children: [
             Placeholder()
           ],
       ),
     ));
  }
}