import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'add_station_details.dart';
import 'colors.dart';
import 'custom_icons.dart';



class SlidingUpPanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.black,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SlidingUpPanel Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          // the fab
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              backgroundColor: Colors.white,
            ),
          ),

          Positioned(
              top: 0,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent,
                      )))),

          //the SlidingUpPanel Title
          Positioned(
            top: 52.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
              child: Text(
                "SlidingUpPanel Example",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Explore Pittsburgh",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button("Popular", Icons.favorite, Colors.blue),
                _button("Food", Icons.restaurant, Colors.red),
                _button("Events", Icons.event, Colors.amber),
                _button("More", Icons.more_horiz, Colors.green),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Images",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("About",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms generating \$20.7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
                  """,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(label),
      ],
    );
  }

  Widget _body() {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(10.9991, 76.9773)
        ));
  }
}
// class opening_overlay extends StatefulWidget {
//   const opening_overlay({super.key});
//
//   @override
//   State<opening_overlay> createState() => _opening_overlayState();
// }
//
// class _opening_overlayState extends State<opening_overlay> {
//
//   TextEditingController _searchController = TextEditingController();
//   onTapStartBtn() async {
//     OverlayLoadingProgress.start(context, barrierDismissible: false);
//     await Future.delayed(const Duration(seconds: 5));
//     OverlayLoadingProgress.stop();
//   }
//
//   onTapStartGifLoadingProgressBtn() async {
//     OverlayLoadingProgress.start(
//         context,
//         gifOrImagePath: 'assets/loading.gif',
//         loadingWidth: 50,
//         barrierDismissible: true
//     );
//     await Future.delayed(const Duration(seconds: 3));
//     OverlayLoadingProgress.stop();
//   }
//
//   onTapStartCustomLoadingProgressBtn() async {
//     OverlayLoadingProgress.start(context,
//         gifOrImagePath: 'assets/loading.gif',
//         barrierDismissible: true,
//         widget: Container(
//           height: 100,
//           width: 100,
//           color: Colors.black38,
//           child: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ));
//     await Future.delayed(const Duration(seconds: 8));
//     OverlayLoadingProgress.stop();
//   }
//
//   void _onSearchIconPressed() {
//     final String searchInput = _searchController.text.toLowerCase();
//     bool foundMatch = false;
//
//     // for (final location in locations) {
//     //   if (location['stationName'].toString().toLowerCase() == searchInput ||
//     //       location['town'].toString().toLowerCase() == searchInput ||
//     //       location['city'].toString().toLowerCase() == searchInput) {
//     //     _moveToLocation(
//     //         location['latitude'] as double, location['longitude'] as double);
//     //     foundMatch = true;
//     //     break;
//     //   }
//     // }
//
//     if (!foundMatch) {
//       print("Failed");
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Location Not Found'),
//             content: Text('The searched location was not found in the list.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//
//   double min_height_sliding=240;
//
//   void show_sliding_panel(){
//     final now = DateTime.now();
//     String greeting = ''; // Default greeting
//
//     if (now.hour >= 3 && now.hour < 12) {
//       greeting = 'Good morning';
//     } else if (now.hour >= 12 && now.hour < 16) {
//       greeting = 'Good afternoon';
//     } else if (now.hour >= 17 && now.hour < 21) {
//       greeting = 'Good evening';
//     } else {
//       greeting = 'Good night';
//     }
//     SlidingUpPanel(
//       onPanelClosed: (){
//         setState(() {
//           min_height_sliding = 0;
//         });
//       },
//       minHeight: min_height_sliding, // Minimum height of the panel
//       panel: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container( //for that scrollable showing
//             width: 40,
//             height: 5,
//             margin: EdgeInsets.symmetric(vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(2.5),
//             ),
//           ),
//           Text(
//             '$greeting, Krupa.',
//             style: TextStyle(
//                 color: GlobalColors.BottomNavIcon,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20),
//             textAlign: TextAlign.left,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Charging stations',
//                 filled: true,
//                 fillColor: Colors
//                     .white, // Set the background color of the TextField
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide.none, // Remove border
//                   borderRadius: BorderRadius.circular(
//                       18), // Add border radius
//                 ),
//                 prefixIcon: IconButton(
//                   onPressed: _onSearchIconPressed,
//                   icon: Icon(Icons.search, size: 23),
//                 ),
//                 suffixIcon: IconButton(
//                   onPressed: () {},
//                   icon: Icon(Custom.equalizer, size: 18),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: Icon(Icons.charging_station_sharp,
//                             size: 28),
//                       ),
//                     ),
//                     Text(
//                       "Find",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     Text(
//                       "Charger",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AddStationDetails(),
//                             ));
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: Colors.transparent,
//                         child: IconButton(
//                           icon: Icon(Icons.add_location_alt_outlined, size: 28),
//                           onPressed: () {},
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Add",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     Text(
//                       "Charger",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       child: IconButton(
//                         onPressed: () {},
//                         icon:
//                         Icon(Icons.route_outlined, size: 28),
//                       ),
//                     ),
//                     Text(
//                       "Quick",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     Text(
//                       "Routes",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Divider(
//             color: Colors.black,
//             height: 23,
//             thickness: 2,
//             indent: 25,
//             endIndent: 25,
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Text("Popular Community",style: TextStyle(fontSize: 24),),
//                 Text("Coming soon...")
//               ],
//             ),
//           ),
//           Divider(
//             color: Colors.black,
//             height: 23,
//             thickness: 2,
//             indent: 25,
//             endIndent: 25,
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Text("Latest updates",style: TextStyle(fontSize: 24),),
//                 Text("Coming soon...")
//               ],
//             ),
//           )
//         ],
//       ),
//       collapsed: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: Center(
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 40,
//                 height: 5,
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(2.5),
//                 ),
//               ),
//               Text(
//                 '$greeting, Krupa.',
//                 style: TextStyle(
//                     color: GlobalColors.BottomNavIcon,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Charging stations',
//                     filled: true,
//                     fillColor: Colors
//                         .white, // Set the background color of the TextField
//                     border: OutlineInputBorder(
//                       borderSide:
//                       BorderSide.none, // Remove border
//                       borderRadius: BorderRadius.circular(
//                           18), // Add border radius
//                     ),
//                     prefixIcon: IconButton(
//                       onPressed: _onSearchIconPressed,
//                       icon: Icon(Icons.search, size: 23),
//                     ),
//                     suffixIcon: IconButton(
//                       onPressed: () {},
//                       icon: Icon(Custom.equalizer, size: 18),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           child: IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                                 Icons.charging_station_sharp,
//                                 size: 28),
//                           ),
//                         ),
//                         Text(
//                           "Find",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         Text(
//                           "Charger",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AddStationDetails(),
//                                 ));
//                           },
//                           child: CircleAvatar(
//                             backgroundColor: Colors.transparent,
//                             child: IconButton(
//                               icon: Icon(Icons.add_location_alt_outlined, size: 28),
//                               onPressed: () {},
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "Add",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         Text(
//                           "Charger",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           child: IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.route_outlined,
//                                 size: 28),
//                           ),
//                         ),
//                         Text(
//                           "Quick",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         Text(
//                           "Routes",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 color: Colors.black,
//                 height: 23,
//                 thickness: 2,
//                 indent: 25,
//                 endIndent: 25,
//               ),
//             ],
//           ),
//         ),
//       ),
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(24),
//         topRight: Radius.circular(24),
//       ),
//     );
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Overlay"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: onTapStartBtn,
//               child: const Text('Start Loading Progress'),
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: onTapStartGifLoadingProgressBtn,
//               child: const Text('Start Gif Loading Progress'),
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: onTapStartCustomLoadingProgressBtn,
//               child: const Text('Start Custom Loading Progress'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
