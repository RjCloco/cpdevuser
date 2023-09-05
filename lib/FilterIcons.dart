import 'package:flutter/material.dart';

import 'custom_icons.dart';

class twoWheeler extends StatefulWidget {
  const twoWheeler({super.key});

  @override
  State<twoWheeler> createState() => _twoWheelerState();
}

class _twoWheelerState extends State<twoWheeler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GestureDetector(
        onTap: () {
          setState(() {

          });
        },
        child: Container(
          height: 55,
          width: 55,
          child: Icon(Custom.motorcycle),
        ),
      ),
    );
  }
}



class fourWheeler extends StatefulWidget {
  const fourWheeler({super.key});

  @override
  State<fourWheeler> createState() => _fourWheelerState();
}

class _fourWheelerState extends State<fourWheeler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GestureDetector(
        onTap: () {
          setState(() {

          });
        },
        child: Container(
          height: 55,
          width: 55,
          child: Icon(Custom.car_side),
        ),
      ),
    );
  }
}

class HeavyVehicle extends StatefulWidget {
  const HeavyVehicle({super.key});

  @override
  State<HeavyVehicle> createState() => _HeavyVehicleState();
}

class _HeavyVehicleState extends State<HeavyVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GestureDetector(
        onTap: () {
          setState(() {

          });
        },
        child: Container(
          height: 55,
          width: 55,
          child: Icon(Custom.truck),
        ),
      ),
    );
  }
}

