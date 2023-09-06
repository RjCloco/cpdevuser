// import 'package:flutter/material.dart';
//
// class ContainerClass extends StatefulWidget {
//
//   String imageUrl;
//   String s1;
//   String s2;
//   VoidCallback onTap;
//   ContainerClass({super.key,required this.imageUrl,required this.s1,required this.s2,required this.onTap});
//
//   @override
//   State<ContainerClass> createState() => _ContainerClassState();
// }
//
// class _ContainerClassState extends State<ContainerClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Image.asset(widget.imageUrl,height: 25,width: 25,),
//           Text(widget.s1),
//           Text(widget.s2),
//
//
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ContainerClass extends StatelessWidget {
  final String imageUrl;
  final String s1;
  final String s2;
  final VoidCallback onTap;

  ContainerClass({
    required this.imageUrl,
    required this.s1,
    required this.s2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, height: 25, width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s1),
              Text(s2),
            ],
          )
        ],
      ),
    );
  }
}
