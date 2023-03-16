// import 'dart:math';
// import 'package:flutter/material.dart';

// class TaskMonster extends StatefulWidget {
//   @override
//   _TaskMonsterState createState() => _TaskMonsterState();
// }

// class _TaskMonsterState extends State<TaskMonster> {
//   late MediaQueryData _mediaQueryData;

//   double _xPos = 0.0;
//   double _yPos = 0.0;

//   @override
//     void didChangeDependencies() {
//     super.didChangeDependencies();
//     _mediaQueryData = MediaQuery.of(context);
//   }
  
//   void initState() {
//     super.initState();
//     _generateRandomPosition();
//   }

//   void _generateRandomPosition() {
//     final random = Random();
//     setState(() {
//       _xPos = random.nextDouble() * MediaQuery.of(context).size.width;
//       _yPos = random.nextDouble() * MediaQuery.of(context).size.height;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _generateRandomPosition();
//       },
//       child: Stack(
//         children: [
//           Positioned(
//             top: _yPos,
//             left: _xPos,
//             child: Image.asset('images/shoggoth.png'),
//           ),
//         ],
//       ),
//     );
//   }
// }
