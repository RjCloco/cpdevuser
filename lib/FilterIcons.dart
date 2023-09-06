// import 'package:flutter/material.dart';
//
// import 'custom_icons.dart';
//
// class twoWheeler extends StatefulWidget {
//   const twoWheeler({super.key});
//
//   @override
//   State<twoWheeler> createState() => _twoWheelerState();
// }
//
// class _twoWheelerState extends State<twoWheeler> {
//   bool colorState = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  GestureDetector(
//         onTap: () {
//           setState(() {
//             colorState =! colorState;
//           });
//         },
//         child: Container(
//           height: 55,
//           width: 55,
//           color: colorState ? Colors.grey : Colors.cyanAccent,
//           child: Icon(Custom.motorcycle),
//
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class fourWheeler extends StatefulWidget {
//   const fourWheeler({super.key});
//
//   @override
//   State<fourWheeler> createState() => _fourWheelerState();
// }
//
// class _fourWheelerState extends State<fourWheeler> {
//   bool colorState = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  GestureDetector(
//         onTap: () {
//           setState(() {
//             colorState =! colorState;
//           });
//         },
//         child: Container(
//           height: 55,
//           width: 55,
//           color: colorState ? Colors.grey : Colors.blueAccent,
//           child: Icon(Custom.car_side),
//
//         ),
//       ),
//     );
//   }
// }
//
// class HeavyVehicle extends StatefulWidget {
//   const HeavyVehicle({super.key});
//
//   @override
//   State<HeavyVehicle> createState() => _HeavyVehicleState();
// }
//
// class _HeavyVehicleState extends State<HeavyVehicle> {
//   bool colorState = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  GestureDetector(
//         onTap: () {
//           setState(() {
//             colorState =! colorState;
//           });
//         },
//         child: Container(
//           height: 55,
//           width: 55,
//           color: colorState ? Colors.grey : Colors.orangeAccent,
//           child: Icon(Custom.truck),
//
//         ),
//       ),
//     );
//   }
// }
//
