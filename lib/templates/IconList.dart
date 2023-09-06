import 'package:cpdevuser/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleIcon extends StatefulWidget {
  final Color initialColor;
  final Color onTapColor;
  final IconData icon;
  final vehicle_name;
  const VehicleIcon({Key? key, required this.icon, required this.initialColor, required this.onTapColor, required this.vehicle_name}) : super(key: key);

  @override
  State<VehicleIcon> createState() => _VehicleIconState();
}

class _VehicleIconState extends State<VehicleIcon>  {
  bool colorState = true;
  @override
  Widget build(BuildContext context) {
    final vehicletypeProvider= Provider.of<ProviderClass>(context);
    return Scaffold(
      body:  GestureDetector(
        onTap: () {
          setState(() {
            colorState =! colorState;
            vehicletypeProvider.vehicleType=widget.vehicle_name;
          });
        },
        child: Container(
          height: 55,
          width: 55,
          color: colorState ? widget.initialColor : widget.onTapColor,
          child: Icon(widget.icon),

        ),
      ),
    );
  }
}

