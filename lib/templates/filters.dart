import 'package:flutter/material.dart';

import '../Provider.dart';

class FiltersIcon extends StatefulWidget {
  String filterName;
  final Color initialColor;
  final Color onTapColor;
  final VoidCallback onTap;
  FiltersIcon({Key? key, required this.filterName, required this.initialColor, required this.onTapColor, required this.onTap}) : super(key: key);

  @override
  State<FiltersIcon> createState() => _FiltersIconState();
}

class _FiltersIconState extends State<FiltersIcon> {
  bool colorState = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  GestureDetector(
        onTap: () {
          setState(() {
            colorState =! colorState;
          });
        },
    child: Card(
        child: Container(
          height: 55,
          width: 55,
          child: Text(
            widget.filterName,style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    ),
    );
  }
}
