import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider.dart';

class FiltersIcon extends StatefulWidget {
  String filterName;
  final Color initialColor;
  final Color onTapColor;
  FiltersIcon({Key? key, required this.filterName, required this.initialColor, required this.onTapColor}) : super(key: key);

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
    child: Card(
        child: Container(
          height: 55,
          width: 55,
          color: colorState ? widget.initialColor : widget.onTapColor,
          child: Text(
            widget.filterName,style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
