import 'package:cpdevuser/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleIcon extends StatefulWidget {
  final IconData icon;
  final vehicle_name;
  final int selectedIndex;
  const VehicleIcon({Key? key, required this.icon, required this.vehicle_name,  required this.selectedIndex}) : super(key: key);

  @override
  State<VehicleIcon> createState() => _VehicleIconState();
}

class _VehicleIconState extends State<VehicleIcon>  {
  @override
  Widget build(BuildContext context) {
    final vehicletypeProvider= Provider.of<ProviderClass>(context);

    final isFirstIcon = vehicletypeProvider.first == widget.selectedIndex;

    final iconColor = isFirstIcon ? Colors.white : Colors.black;
    final backgroundColor = isFirstIcon ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () {
        setState(() {
          vehicletypeProvider.vehicleType=widget.vehicle_name;
          vehicletypeProvider.swapWithFirst(widget.selectedIndex);
        });
      },
        child: Container(
          height: 45,
          width: 45,
          color: backgroundColor,
          child: Icon(
            widget.icon,
            color: iconColor, // Icon color
          ),

        ),
      );
  }
}

// bool isTapped = vehicletypeProvider.index == widget.selectedIndex;
// var temp;

// onTap: () {
//   setState(() {
//     colorState =! colorState;
//     vehicletypeProvider.vehicleType=widget.vehicle_name;
//     print('Index : ${vehicletypeProvider.index}');
//     print('Selected index : ${widget.selectedIndex}');
//     print('Before Swap 1st index: ${vehicletypeProvider.first}');
//     print('Before Swap 2nd index: ${vehicletypeProvider.second}');
//     print('Before Swap 3rd index: ${vehicletypeProvider.third}');
//     if( vehicletypeProvider.index != widget.selectedIndex){
//       setState(() {
//         temp=widget.selectedIndex;
//         vehicletypeProvider.first= vehicletypeProvider.index;
//         vehicletypeProvider.second=temp;
//         print('initial index: ${vehicletypeProvider.index}');
//         print('Swapped 1st index: ${vehicletypeProvider.first}');
//         print('Swapped 2nd index: ${vehicletypeProvider.second}');
//         print('Swapped 3rd index: ${vehicletypeProvider.third}');
//         print('${widget.selectedIndex}');
//         // vehicletypeProvider.third=2;
//         // vehicletypeProvider.first=1;
//         // vehicletypeProvider.second=temp;
//       });
//     }
//   });
// },

// if (!isTapped) {
//   setState(() {
//     vehicletypeProvider.first = vehicletypeProvider.index;
//     vehicletypeProvider.second = widget.selectedIndex;
//     vehicletypeProvider.index = widget.selectedIndex;
//   });
// }