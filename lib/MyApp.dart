import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'bottomNavBar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create:  (context) => ProviderClass(),),
      ],
      child:
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        //home: PhoneVerify(),
        home: navPage(),
      ),
    );
  }
}




// class _Map2State extends State<Map2> {
//   Completer<GoogleMapController> _controller = Completer();
//   CustomInfoWindowController _customInfoWindowController =
//   CustomInfoWindowController();
//
//   static const LatLng funmall = LatLng(11.0247, 77.0106); //Fun mall
//   static const LatLng lakshmicomplex = LatLng(11.0169, 76.9655); //lakshmi complex
//   static const LatLng racecourse = LatLng(10.9991, 76.9773);
//   static const LatLng prozone = LatLng(11.0548, 76.9941);
//
//   LocationData? currentLocation;
//
//   void getCurrentLocation() {
//     Location location = Location();
//
//     location.getLocation().then((location) {
//       setState(() {
//         currentLocation = location;
//       });
//     });
//   }
//
//
//   late List<Marker> _otherMarkers ;
//
//   BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
//
//   addCustomIcon()  async{
//     BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(0.5,0.5)),
//         'assets/img.png')
//         .then((icon) {
//       setState(() {
//         markerIcon = icon;
//       });
//       // markerIcon = icon;
//     }
//     );
//
//     final Uint8List markIcons = await getImages('assets/img.png', 50);
//   }
//
//   Future<Uint8List> getImages(String path, int width) async{
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
//
//   }
//
//   void centerMapToCurrentLocation() {
//     if (_controller.isCompleted && currentLocation != null) {
//       _controller.future.then((controller) {
//         controller.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//           ),
//         );
//       });
//     }
//   }
//   TextEditingController _searchController = TextEditingController();
//
//   List<Map<String, dynamic>> locations = [
//     {'latitude': 11.0247, 'longitude': 77.0106, 'stationName': 'Fun Mall','town': 'Peelamedu','city':'Coimbatore'},
//     {'latitude': 11.0169, 'longitude': 76.9655, 'stationName': 'Lakshmi Complex','town': 'Gandhipuram','city':'Coimbatore'},
//     {'latitude': 11.0548,'longitude': 76.9941, 'stationName' : 'Prozone','town': 'Saravanampatti','city':'Coimbatore'},
//   ];
//
//   void _onSearchIconPressed() {
//     final String searchInput = _searchController.text.toLowerCase();
//     bool foundMatch = false;
//
//     for (final location in locations) {
//       if (location['stationName'].toString().toLowerCase() == searchInput ||
//           location['town'].toString().toLowerCase() == searchInput ||
//           location['city'].toString().toLowerCase() == searchInput) {
//         _moveToLocation(location['latitude'] as double, location['longitude'] as double);
//         foundMatch = true;
//         break;
//       }
//     }
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
//   void _moveToLocation(double latitude, double longitude) {
//     if (_controller.isCompleted) {
//       _controller.future.then((controller) {
//         controller.animateCamera(
//           CameraUpdate.newLatLng(LatLng(latitude, longitude)),
//         );
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _customInfoWindowController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     getCurrentLocation();
//     addCustomIcon().then((_) {
//       _otherMarkers = [
//         Marker(
//           markerId: const MarkerId("Lakshmi Complex"),
//           position: lakshmicomplex,
//           onTap: () {
//             _customInfoWindowController.addInfoWindow!(
//               GestureDetector(
//                 onTap: (){
//                   _onMarkerTapped('Lakshmi Complex', 'Charging station',11.0169, 76.9655);
//                 },
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green[700],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.account_circle,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             Text(
//                               "Lakshmi complex",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             Text(
//                               "Charging station",
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         ),
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Triangle.isosceles(
//                       edge: Edge.BOTTOM,
//                       child: Container(
//                         color: Colors.green[700],
//                         width: 20.0,
//                         height: 10.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               lakshmicomplex,
//             );
//           },
//           icon: markerIcon,
//         ),
//         Marker(
//           markerId: const MarkerId("Fun Mall"),
//           position: funmall,
//           onTap: () {
//             _customInfoWindowController.addInfoWindow!(
//               GestureDetector(
//                 onTap: (){
//                   _onMarkerTapped('Fun Mall', 'Mall',11.0247, 77.0106);
//                 },
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green[700],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.account_circle,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             Text(
//                               "Fun Mall",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             Text(
//                               "Mall",
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         ),
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Triangle.isosceles(
//                       edge: Edge.BOTTOM,
//                       child: Container(
//                         color: Colors.green[700],
//                         width: 20.0,
//                         height: 10.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               funmall,
//             );
//           },
//           icon: markerIcon,
//         ),
//         Marker(
//           markerId: const MarkerId("Prozone Mall"),
//           position: prozone,
//           onTap: () {
//             _customInfoWindowController.addInfoWindow!(
//               GestureDetector(
//                 onTap: (){
//                   _onMarkerTapped('Prozone Mall', 'Mall',11.0548, 76.9941);
//                 },
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green[700],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.account_circle,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             Text(
//                               "Prozone",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             Text(
//                               "Mall",
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         ),
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Triangle.isosceles(
//                       edge: Edge.BOTTOM,
//                       child: Container(
//                         color: Colors.green[700],
//                         width: 20.0,
//                         height: 10.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               prozone,
//             );
//           },
//           icon: markerIcon,
//         ),
//       ];
//       setState(() {});
//     });
//
//     super.initState();
//   }
//
//   _onMarkerTapped(String name, String snippet,double latitude, double longitude) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MarkerDetailsPage(title: name, snippet: snippet,lat: latitude ,long:longitude),
//       ),
//     );
//   }
//
//   int selectedIconIndex = 0; // 0 for truck, 1 for car, 2 for motorcycle
//
//   List<String> texts =
//   [
//     'Fast CCS2',
//     'Slow type 2',
//     'Slow 15A',
//     'Fast DC-001',
//     'fast CHAde',
//     'Slow IEC AC',
//     'Fast type 6',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         final shouldPop = await showDialog<bool>(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Do you want to go back?'),
//               actionsAlignment: MainAxisAlignment.spaceAround,
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, true);
//                   },
//                   child: const Text('Yes'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   },
//                   child: const Text('No'),
//                 ),
//               ],
//             );
//           },
//         );
//         return shouldPop!;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Container(
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Row(
//                 children: [
//                   Image.asset(
//                     "assets/chargePartnersLogo.png",
//                     height: 37,
//                     alignment:Alignment.bottomLeft ,
//                   ),
//                   Flexible(
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Charging stations',
//                         filled: true,
//                         fillColor: Colors.white, // Set the background color of the TextField
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none, // Remove border
//                           borderRadius: BorderRadius.circular(18), // Add border radius
//                         ),
//                         prefixIcon: IconButton(
//                           onPressed: _onSearchIconPressed,
//                           icon: Icon(Icons.search,size: 23),
//                         ),
//                         suffixIcon: IconButton(
//                           onPressed: (){
//
//                           },
//                           icon: Icon(Custom.equalizer,size: 18),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                       onPressed: (){},
//                       icon: Icon(Icons.notifications_active,size: 21)
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: currentLocation == null
//             ? Center(child: CircularProgressIndicator())
//             : Stack(
//           children: [
//             Positioned.fill(
//               child: GoogleMap(
//                 onMapCreated: (GoogleMapController controller) async {
//                   _customInfoWindowController.googleMapController = controller;
//                   _controller.complete(controller);
//                 },
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//                   zoom: 15,
//                 ),
//                 onTap: (position) {
//                   _customInfoWindowController.hideInfoWindow!();
//                 },
//                 onCameraMove: (position) {
//                   _customInfoWindowController.onCameraMove!();
//                 },
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 markers: Set<Marker>.from(_otherMarkers),
//               ),
//             ),
//             // Positioned(
//             //     child:
//             //     Padding(
//             //       padding: const EdgeInsets.all(8.0),
//             //       child: Column(
//             //         children: [
//             //           Row(
//             //             children: [
//             //               Card(
//             //                 child: Container(
//             //                   height: 55,
//             //                   width: 55,
//             //                   child: Icon(Custom.truck),
//             //                 ),
//             //               ),
//             //               Container(
//             //                 height: 60,
//             //                 width: MediaQuery.of(context).size.width - 90, // Adjust the width as needed
//             //                 child: SingleChildScrollView(
//             //                   physics: ScrollPhysics(),
//             //                   scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
//             //                   child:
//             //                   ListView.builder(
//             //                     scrollDirection: Axis.horizontal, // Set the inner ListView to scroll horizontally
//             //                     shrinkWrap: true,
//             //                     itemCount: 7,
//             //                     itemBuilder: (context, index) {
//             //                       // List of texts to display in the containers
//             //                       List<String> texts = [
//             //                         'Fast CCS2',
//             //                         'Slow type 2',
//             //                         'Slow 15A',
//             //                         'Fast DC-001',
//             //                         'fast CHAde',
//             //                         'Slow IEC AC',
//             //                         'Fast type 6',
//             //                       ];
//             //                       return Padding(
//             //                         padding: const EdgeInsets.all(8.0), // spacing between items
//             //                         child: Card(
//             //                           child: Container(
//             //                             height: 55,
//             //                             width: 55,
//             //                             child: Text(texts[index], style: TextStyle(fontSize: 12)),
//             //                           ),
//             //                         ),
//             //                       );
//             //                     },
//             //                   ),
//             //                 ),
//             //               ),
//             //
//             //             ],
//             //           ),
//             //           Row(
//             //             children: [
//             //               Card(
//             //                 child: Container(
//             //                   height: 55,
//             //                   width: 55,
//             //                   child: Icon(Custom.car_side),
//             //                 ),
//             //               ),
//             //               Container(
//             //                 height: 60,
//             //                 width: MediaQuery.of(context).size.width - 90, // Adjust the width as needed
//             //                 child: SingleChildScrollView(
//             //                   physics: ScrollPhysics(),
//             //                   scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
//             //                   child:
//             //                   ListView.builder(
//             //                     scrollDirection: Axis.horizontal, // Set the inner ListView to scroll horizontally
//             //                     shrinkWrap: true,
//             //                     itemCount: 7,
//             //                     itemBuilder: (context, index) {
//             //                       // List of texts to display in the containers
//             //                       List<String> texts = [
//             //                         'Fast CCS2',
//             //                         'Slow type 2',
//             //                         'Slow 15A',
//             //                         'Fast DC-001',
//             //                         'fast CHAde',
//             //                         'Slow IEC AC',
//             //                         'Fast type 6',
//             //                       ];
//             //                       return Padding(
//             //                         padding: const EdgeInsets.all(8.0), // spacing between items
//             //                         child: Card(
//             //                           child: Container(
//             //                             height: 55,
//             //                             width: 55,
//             //                             child: Text(texts[index], style: TextStyle(fontSize: 12)),
//             //                           ),
//             //                         ),
//             //                       );
//             //                     },
//             //                   ),
//             //                 ),
//             //               ),
//             //
//             //             ],
//             //           ),
//             //           Row(
//             //             children: [
//             //               Card(
//             //                 child: Container(
//             //                   height: 55,
//             //                   width: 55,
//             //                   child: Icon(Custom.motorcycle),
//             //                 ),
//             //               ),
//             //               Container(
//             //                 height: 60,
//             //                 width: MediaQuery.of(context).size.width - 90, // Adjust the width as needed
//             //                 child: SingleChildScrollView(
//             //                   physics: ScrollPhysics(),
//             //                   scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
//             //                   child:
//             //                   ListView.builder(
//             //                     scrollDirection: Axis.horizontal, // Set the inner ListView to scroll horizontally
//             //                     shrinkWrap: true,
//             //                     itemCount: 7,
//             //                     itemBuilder: (context, index) {
//             //                       // List of texts to display in the containers
//             //                       List<String> texts = [
//             //                         'Fast CCS2',
//             //                         'Slow type 2',
//             //                         'Slow 15A',
//             //                         'Fast DC-001',
//             //                         'fast CHAde',
//             //                         'Slow IEC AC',
//             //                         'Fast type 6',
//             //                       ];
//             //                       return Padding(
//             //                         padding: const EdgeInsets.all(8.0), // spacing between items
//             //                         child: Card(
//             //                           child: Container(
//             //                             height: 55,
//             //                             width: 55,
//             //                             child: Text(texts[index], style: TextStyle(fontSize: 12)),
//             //                           ),
//             //                         ),
//             //                       );
//             //                     },
//             //                   ),
//             //                 ),
//             //               ),
//             //
//             //             ],
//             //           ),
//             //         ],
//             //       ),
//             //     )
//             //
//             // ),
//             Positioned(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Card(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIconIndex = 0; // Truck icon tapped
//                               });
//                             },
//                             child: Container(
//                               height: 55,
//                               width: 55,
//                               child: Icon(Custom.truck),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 60,
//                           width: MediaQuery.of(context).size.width - 90,
//                           child: SingleChildScrollView(
//                             physics: ScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             child: Visibility(
//                               visible: selectedIconIndex == 0,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemCount: texts.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Card(
//                                       child: Container(
//                                         height: 55,
//                                         width: 55,
//                                         child: Text(
//                                           texts[index],
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Card(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIconIndex = 1; // Car icon tapped
//                               });
//                             },
//                             child: Container(
//                               height: 55,
//                               width: 55,
//                               child: Icon(Custom.car_side),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 60,
//                           width: MediaQuery.of(context).size.width - 90,
//                           child: SingleChildScrollView(
//                             physics: ScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             child: Visibility(
//                               visible: selectedIconIndex == 1,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemCount: texts.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Card(
//                                       child: Container(
//                                         height: 55,
//                                         width: 55,
//                                         child: Text(
//                                           texts[index],
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Card(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIconIndex = 2; // Motorcycle icon tapped
//                               });
//                             },
//                             child: Container(
//                               height: 55,
//                               width: 55,
//                               child: Icon(Custom.motorcycle),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 60,
//                           width: MediaQuery.of(context).size.width - 90,
//                           child: SingleChildScrollView(
//                             physics: ScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             child: Visibility(
//                               visible: selectedIconIndex == 2,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemCount: texts.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Card(
//                                       child: Container(
//                                         height: 55,
//                                         width: 55,
//                                         child: Text(
//                                           texts[index],
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SlidingUpPanel(
//                 minHeight: 220, // Minimum height of the panel
//                 panel: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 5,
//                       margin: EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     Text(
//                       'Good Afternoon, Krupa. ext',
//                       style: TextStyle(
//                         color: GlobalColors.BottomNavIcon,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text("Expanded version"),
//                     ),
//                   ],
//                 ),
//                 collapsed: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                   child: Center(
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 5,
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.circular(2.5),
//                           ),
//                         ),
//                         Text(
//                           'Good Afternoon, Krupa.',
//                           style: TextStyle(
//                               color: GlobalColors.BottomNavIcon,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                           child: TextField(
//                             controller: _searchController,
//                             decoration: InputDecoration(
//                               hintText: 'Charging stations',
//                               filled: true,
//                               fillColor: Colors.white, // Set the background color of the TextField
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide.none, // Remove border
//                                 borderRadius: BorderRadius.circular(18), // Add border radius
//                               ),
//                               prefixIcon: IconButton(
//                                 onPressed: _onSearchIconPressed,
//                                 icon: Icon(Icons.search,size: 23),
//                               ),
//                               suffixIcon: IconButton(
//                                 onPressed: (){
//
//                                 },
//                                 icon: Icon(Custom.equalizer,size: 18),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.transparent,
//                                     child: IconButton(
//                                       onPressed: (){ },
//                                       icon: Icon(Icons.charging_station_sharp,size: 28),
//                                     ),
//                                   ),
//                                   Text("Find",style: TextStyle(fontSize: 12),),
//                                   Text("Charger",style: TextStyle(fontSize: 12),),
//                                 ],
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.transparent,
//                                     child: IconButton(
//                                       onPressed: (){ },
//                                       icon: Icon(Icons.add_location_alt_outlined,size: 28),
//                                     ),
//                                   ),
//                                   Text("Add",style: TextStyle(fontSize: 12),),
//                                   Text("Charger",style: TextStyle(fontSize: 12),),
//                                 ],
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.transparent,
//                                     child: IconButton(
//                                       onPressed: (){ },
//                                       icon: Icon(Icons.message_outlined,size: 28),
//                                     ),
//                                   ),
//                                   Text("EV",style: TextStyle(fontSize: 12),),
//                                   Text("Channels",style: TextStyle(fontSize: 12),),
//                                 ],
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.transparent,
//                                     child: IconButton(
//                                       onPressed: (){ },
//                                       icon: Icon(Icons.route_outlined,size: 28),
//                                     ),
//                                   ),
//                                   Text("Quick",style: TextStyle(fontSize: 12),),
//                                   Text("Routes",style: TextStyle(fontSize: 12),),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//             ),
//             CustomInfoWindow(
//               controller: _customInfoWindowController,
//               height: 75,
//               width: 150,
//               offset: 50,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// Positioned(
//   top: 90,
//   right: 15,
//   child: CircleAvatar(
//     backgroundColor: Colors.green[700],
//     radius: 28,
//     child: IconButton(
//       onPressed:(){
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) =>  QRViewExample())
//         );
//       },
//       icon:const Icon(Icons.qr_code),
//       color: Colors.white,
//     ),
//   ),
// ),
// Positioned(
//   top: 155,
//   right: 15,
//   child: CircleAvatar(
//     backgroundColor: Colors.green[700],
//     radius: 28,
//     child: IconButton(
//       onPressed: centerMapToCurrentLocation, // Call the function here
//       icon: const Icon(Icons.my_location_outlined),
//       color: Colors.white,
//     ),
//   ),
// ),