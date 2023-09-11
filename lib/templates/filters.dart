import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider.dart';

class FiltersIcon extends StatefulWidget {
  String filterName;
  final decoration;
  FiltersIcon({Key? key, required this.filterName, required this.decoration}) : super(key: key);

  @override
  State<FiltersIcon> createState() => _FiltersIconState();
}

class _FiltersIconState extends State<FiltersIcon> {
  bool colorState = true;
  @override
  Widget build(BuildContext context) {
    final vehicletypeProvider = Provider.of<ProviderClass>(context);
    return  GestureDetector(
        onTap: () {
          setState(() {
            colorState =! colorState;
            print("Vehicle type : ${vehicletypeProvider.vehicleType}, Filter type: ${widget.filterName}");
          });
        },
    child: Container(
      decoration: colorState ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.elliptical(20, 25),
        )
      ): widget.decoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 0,bottom: 0,left: 8,right: 8),
        child: Center(
          child: Text(
            widget.filterName,style: TextStyle(fontSize: 8,fontWeight: FontWeight.w600,),
          ),
        ),
      ),
    ),
    );
  }
}
