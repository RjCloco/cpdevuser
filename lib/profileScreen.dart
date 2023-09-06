import 'package:cpdevuser/profilescreentemplate.dart';
import 'package:flutter/material.dart';

import 'colors.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  // var list=ContainerClass(imageUrl: "assets/bike.png",s1:"Your Vehicle",s2:"View & Update of Your Electric Vehicle",);
  // var list=ContainerClass(imageUrl: "assets/favourites.png",s1:"Favorites",s2:" ",);
  //var list=ContainerClass(imageUrl: "assets/messages.png",s1:"Direct Messages",s2:" ",);
  //var list=ContainerClass(imageUrl: "assets/contacts.png",s1:"Invite a Friend",s2:" ",);
  //var list=ContainerClass(imageUrl: "assets/book.png",s1:"Help & Support",s2:"Contact,Feedback,Terms,Privacy",);
  //var list=ContainerClass(imageUrl: "assets/book.png",s1:"Education",s2:" ",);
  //var list=ContainerClass(imageUrl: "assets/plus.png",s1:"Add Charge Station",s2:"Based on Location",);
  //var list=ContainerClass(imageUrl: "assets/pen.png",s1:"Others",s2:" ",);
  //var list=ContainerClass(imageUrl: "assets/triangle.png",s1:"Charge Error Codes",s2:"Caution Properties",);
  //var list=ContainerClass(imageUrl: "assets/bike.png",s1:"Connect with Us Online",s2:" For further important details",);


  @override
  Widget build(BuildContext context) {
    var list1 = [
      ContainerClass(imageUrl: "assets/bike.png",
          s1: "Your Vehicle",
          s2: "View & Update of Your Electric Vehicle",
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => profile()),
            // );
          }),
      ContainerClass(
        imageUrl: "assets/fav.png",
        s1: "Favorites",
        s2: " ",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/messages.png",
        s1: "Direct Messages",
        s2: " ",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/contacts.png",
        s1: "Invite a Friend",
        s2: " ",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/book.png",
        s1: "Help & Support",
        s2: "Contact,Feedback,Terms,Privacy",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/book.png", s1: "Education", s2: " ", onTap: () {},),
      ContainerClass(
        imageUrl: "assets/plus.png",
        s1: "Add Charge Station",
        s2: "Based on Location",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/pen.png", s1: "Others", s2: " ", onTap: () {},),
      ContainerClass(
        imageUrl: "assets/triangle.png",
        s1: "Charge Error Codes",
        s2: "Caution Properties",
        onTap: () {},),
      ContainerClass(
        imageUrl: "assets/bike.png",
        s1: "Connect with Us Online",
        s2: " For further important details",
        onTap: () {},)
    ];
    return Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalColors.color1,
                    GlobalColors.color4,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: GlobalColors.color5,
                            radius: 18.0,
                            child: Icon(
                              Icons.edit,
                              size: 24.0,
                              color: GlobalColors.color4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list1.length * 2 - 1, // Double the number of items to account for dividers
                itemBuilder: (BuildContext context, int index) {
                  if (index.isOdd) {
                    // Calculate the index of the corresponding item
                    final itemIndex = index ~/ 2;
                    return Divider(
                      color: Colors.grey
                      , // Set the color of the divider
                    );
                  } else {
                    // Display your list item
                    final itemIndex = index ~/ 2;
                    return list1[itemIndex]; // Return the actual list item
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}