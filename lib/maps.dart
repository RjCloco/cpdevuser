import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpdevuser/Provider.dart';
import 'package:cpdevuser/colors.dart';
import 'package:cpdevuser/templates/IconList.dart';
import 'package:cpdevuser/templates/filters.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'add_station.dart';
import 'add_station_details.dart';
import 'custom_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'map_launcher.dart';

class Map2 extends StatefulWidget {
  const Map2({Key? key}) : super(key: key);

  @override
  State<Map2> createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  Completer<GoogleMapController> _controller = Completer();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  double min_height_sliding=240;
  bool isPanelVisible = true;
  static const LatLng funmall = LatLng(11.0247, 77.0106); //Fun mall
  static const LatLng lakshmicomplex =
      LatLng(11.0169, 76.9655); //lakshmi complex
  static const LatLng racecourse = LatLng(10.9991, 76.9773);
  static const LatLng prozone = LatLng(11.0548, 76.9941);

  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });
  }

  late List<Marker> _otherMarkers;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Future<BitmapDescriptor> createCustomMarkerIcon(String iconImage, Color borderColor) async {
    final width = 60; // Adjust the marker width as needed
    final height = 60; // Adjust the marker height as needed

    final recorder = PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset(0.0, 0.0), Offset(width.toDouble(), height.toDouble())),
    );

    // Draw a circle shape with a border
    final paint = Paint()
      ..color = borderColor // Set the border color
      ..style = PaintingStyle.fill;

    final radius = width / 2;
    final centerX = width / 2;
    final centerY = height / 2;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Load and draw the icon image in the center
    final ByteData imageData = await rootBundle.load(iconImage);
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final imageWidth = fi.image.width.toDouble();
    final imageHeight = fi.image.height.toDouble();
    final imageOffsetX = (width - imageWidth) / 2;
    final imageOffsetY = (height - imageHeight) / 2;

    canvas.drawImageRect(
      fi.image,
      Rect.fromLTRB(0, 0, imageWidth, imageHeight),
      Rect.fromPoints(
        Offset(imageOffsetX, imageOffsetY),
        Offset(imageOffsetX + imageWidth, imageOffsetY + imageHeight),
      ),
      Paint(),
    );

    final img = await recorder.endRecording().toImage(width, height);
    final imageDataBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(imageDataBytes!.buffer.asUint8List());
  }
  //
  // void addCustomMarker(GoogleMapController controller, LatLng position, String iconImage, Color borderColor) {
  //   createCustomMarkerIcon(iconImage, borderColor).then((customIcon) {
  //     final marker = Marker(
  //       markerId: MarkerId('custom_marker_${_otherMarkers.length}'),
  //       position: position,
  //       icon: customIcon,
  //       onTap: () {
  //         _onMarkerTapped('Custom Marker', 'Charging station', position.latitude, position.longitude);
  //       },
  //     );
  //
  //     setState(() {
  //       _otherMarkers.add(marker);
  //     });
  //   });
  // }

  addCustomIcon() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(5.5, 5.5)), 'assets/chargePartnersLogo.png')
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
      // markerIcon = icon;
    });

    final Uint8List markIcons = await getImages('assets/chargePartnersLogo.png', 150);
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void centerMapToCurrentLocation() {
    if (_controller.isCompleted && currentLocation != null) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
        );
      });
    }
  }

  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> locations = [
    {
      'latitude': 11.0247,
      'longitude': 77.0106,
      'stationName': 'Fun Mall',
      'town': 'Peelamedu',
      'city': 'Coimbatore'
    },
    {
      'latitude': 11.0169,
      'longitude': 76.9655,
      'stationName': 'Lakshmi Complex',
      'town': 'Gandhipuram',
      'city': 'Coimbatore'
    },
    {
      'latitude': 11.0548,
      'longitude': 76.9941,
      'stationName': 'Prozone',
      'town': 'Saravanampatti',
      'city': 'Coimbatore'
    },
  ];

  void _onSearchIconPressed() {
    final String searchInput = _searchController.text.toLowerCase();
    bool foundMatch = false;

    for (final location in locations) {
      if (location['stationName'].toString().toLowerCase() == searchInput ||
          location['town'].toString().toLowerCase() == searchInput ||
          location['city'].toString().toLowerCase() == searchInput) {
        _moveToLocation(
            location['latitude'] as double, location['longitude'] as double);
        foundMatch = true;
        break;
      }
    }

    if (!foundMatch) {
      print("Failed");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Not Found'),
            content: Text('The searched location was not found in the list.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _moveToLocation(double latitude, double longitude) {
    if (_controller.isCompleted) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude, longitude)),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
    _customInfoWindowController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   getCurrentLocation();
  //   addCustomIcon().then((_) {
  //     _otherMarkers = [
  //       Marker(
  //         markerId: const MarkerId("Lakshmi Complex"),
  //         position: lakshmicomplex,
  //         onTap: () {
  //           _customInfoWindowController.addInfoWindow!(
  //             GestureDetector(
  //               onTap: () {
  //                 _onMarkerTapped(
  //                     'Lakshmi Complex', 'Charging station', 11.0169, 76.9655);
  //               },
  //               child: Column(
  //                 children: [
  //                   Expanded(
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.green[700],
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.account_circle,
  //                             color: Colors.white,
  //                             size: 30,
  //                           ),
  //                           Text(
  //                             "Lakshmi complex",
  //                             style: TextStyle(color: Colors.black),
  //                           ),
  //                           Text(
  //                             "Charging station",
  //                             style: TextStyle(color: Colors.white),
  //                           )
  //                         ],
  //                       ),
  //                       width: double.infinity,
  //                       height: double.infinity,
  //                     ),
  //                   ),
  //                   Triangle.isosceles(
  //                     edge: Edge.BOTTOM,
  //                     child: Container(
  //                       color: Colors.green[700],
  //                       width: 20.0,
  //                       height: 10.0,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             lakshmicomplex,
  //           );
  //         },
  //         icon: markerIcon,
  //       ),
  //     ];
  //     setState(() {});
  //   });
  //
  //   super.initState();
  // }

  Future<List<DocumentSnapshot>> fetchData() async {
    // Get a reference to the 'StationManagement' collection
    CollectionReference stationCollection = FirebaseFirestore.instance.collection('StationManagement');

    try {
      QuerySnapshot querySnapshot = await stationCollection.where('ActiveStatus', isEqualTo: true).get();
      return querySnapshot.docs;
    } catch (error) {
      // Handle any errors that occur during the data fetch
      print('Error fetching data: $error');
      return [];
    }
  }



  Future<void> DBAddStation()async {
    String collectionName = 'StationManagement'; // Replace with your desired collection name
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);
    final DocumentSnapshot docSnapshot = await collectionRef.doc('Lakshmi Mills').get();
    await collectionRef.doc('Lakshmi Mills').set({
      'ActiveStatus': true,
      'Address': {
        'City': 'Coimbatore',
        'State':'Tamil Nadu',
        'PinCode':641062,
      },
      'CreatedAt':  DateTime.now(),
      'Latitude':11.0169,
      'Longitude':76.9655,
      'StationName': 'Lakshmi Mills',
      'Description': 'Lakshmi complex'
      // Add other fields if required

    });

  }

  Future<void>  AddStationdata(List<DocumentSnapshot<Object?>> stationData) async {

    for (var document in stationData) {
      _otherMarkers.add(
        Marker(
          markerId:MarkerId(document['StationName']),
          position: LatLng(document['Latitude'],document['Longitude']),
          infoWindow: InfoWindow(
            title: document['StationName'],
            snippet:document['Description'],
            onTap: () {
              _onMarkerTapped(document['ChargingStation'], document['Description'],document['Latitude'], document['Longitude']);
            },
          ),
          icon: markerIcon,
          // icon: await MarkerIcon.downloadResizePictureCircle(
          //     'assets/image2.png',
          //     size: 40,
          //     addBorder: true,
          //     borderColor: Colors.white,
          //     borderSize: 15
          // ),
        ),
      );// Add more fields as needed
      print(_otherMarkers);
    }
  }

  @override
  void initState() {
    // onStartApp();
    getCurrentLocation();
    createCustomMarkerIcon('assets/chargePartnersLogo.png', Colors.blue).then((customIcon) {
      _otherMarkers = [
        Marker(
          markerId: const MarkerId("Lakshmi Complex"),
          position: lakshmicomplex,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              GestureDetector(
                onTap: () {
                  _onMarkerTapped(
                      'Lakshmi Complex', 'Charging station', 11.0169, 76.9655);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Lakshmi complex",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Charging station",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Triangle.isosceles(
                      edge: Edge.BOTTOM,
                      child: Container(
                        color: Colors.green[700],
                        width: 20.0,
                        height: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              lakshmicomplex,
            );
          },
          icon: customIcon, // Use the customIcon here
        ),
      ];
      setState(() {});
    });

    super.initState();
  }



  _onMarkerTapped(
      String name, String snippet, double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerDetailsPage(
            title: name, snippet: snippet, lat: latitude, long: longitude),
      ),
    );
  }

  Future getData() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return;
  }

  // onStartApp() async {
  //   final now = DateTime.now();
  //   String greeting = ''; // Default greeting
  //
  //   if (now.hour >= 3 && now.hour < 12) {
  //     greeting = 'Good morning';
  //   } else if (now.hour >= 12 && now.hour < 16) {
  //     greeting = 'Good afternoon';
  //   } else if (now.hour >= 17 && now.hour < 21) {
  //     greeting = 'Good evening';
  //   } else {
  //     greeting = 'Good night';
  //   }
  //   OverlayLoadingProgress.start(context, barrierDismissible: false);
  //   SlidingUpPanel(
  //     onPanelClosed: (){
  //       setState(() {
  //         min_height_sliding = 0;
  //       });
  //     },
  //     minHeight: min_height_sliding, // Minimum height of the panel
  //     panel: Column(
  //       // mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container( //for that scrollable showing
  //           width: 40,
  //           height: 5,
  //           margin: EdgeInsets.symmetric(vertical: 10),
  //           decoration: BoxDecoration(
  //             color: Colors.grey,
  //             borderRadius: BorderRadius.circular(2.5),
  //           ),
  //         ),
  //         Text(
  //           '$greeting, Krupa.',
  //           style: TextStyle(
  //               color: GlobalColors.BottomNavIcon,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 20),
  //           textAlign: TextAlign.left,
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //           child: TextField(
  //             controller: _searchController,
  //             decoration: InputDecoration(
  //               hintText: 'Charging stations',
  //               filled: true,
  //               fillColor: Colors
  //                   .white, // Set the background color of the TextField
  //               border: OutlineInputBorder(
  //                 borderSide: BorderSide.none, // Remove border
  //                 borderRadius: BorderRadius.circular(
  //                     18), // Add border radius
  //               ),
  //               prefixIcon: IconButton(
  //                 onPressed: _onSearchIconPressed,
  //                 icon: Icon(Icons.search, size: 23),
  //               ),
  //               suffixIcon: IconButton(
  //                 onPressed: () {},
  //                 icon: Icon(Custom.equalizer, size: 18),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CircleAvatar(
  //                     backgroundColor: Colors.transparent,
  //                     child: IconButton(
  //                       onPressed: () {},
  //                       icon: Icon(Icons.charging_station_sharp,
  //                           size: 28),
  //                     ),
  //                   ),
  //                   Text(
  //                     "Find",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                   Text(
  //                     "Charger",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => AddStationDetails(),
  //                           ));
  //                     },
  //                     child: CircleAvatar(
  //                       backgroundColor: Colors.transparent,
  //                       child: IconButton(
  //                         icon: Icon(Icons.add_location_alt_outlined, size: 28),
  //                         onPressed: () {},
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     "Add",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                   Text(
  //                     "Charger",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CircleAvatar(
  //                     backgroundColor: Colors.transparent,
  //                     child: IconButton(
  //                       onPressed: () {},
  //                       icon:
  //                       Icon(Icons.route_outlined, size: 28),
  //                     ),
  //                   ),
  //                   Text(
  //                     "Quick",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                   Text(
  //                     "Routes",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //           height: 23,
  //           thickness: 2,
  //           indent: 25,
  //           endIndent: 25,
  //         ),
  //         Container(
  //           child: Column(
  //             children: [
  //               Text("Popular Community",style: TextStyle(fontSize: 24),),
  //               Text("Coming soon...")
  //             ],
  //           ),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //           height: 23,
  //           thickness: 2,
  //           indent: 25,
  //           endIndent: 25,
  //         ),
  //         Container(
  //           child: Column(
  //             children: [
  //               Text("Latest updates",style: TextStyle(fontSize: 24),),
  //               Text("Coming soon...")
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //     collapsed: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(24),
  //           topRight: Radius.circular(24),
  //         ),
  //       ),
  //       child: Center(
  //         child: Column(
  //           // mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 5,
  //               margin: EdgeInsets.symmetric(vertical: 10),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey,
  //                 borderRadius: BorderRadius.circular(2.5),
  //               ),
  //             ),
  //             Text(
  //               '$greeting, Krupa.',
  //               style: TextStyle(
  //                   color: GlobalColors.BottomNavIcon,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20),
  //               textAlign: TextAlign.left,
  //             ),
  //             Padding(
  //               padding:
  //               const EdgeInsets.symmetric(horizontal: 30.0),
  //               child: TextField(
  //                 controller: _searchController,
  //                 decoration: InputDecoration(
  //                   hintText: 'Charging stations',
  //                   filled: true,
  //                   fillColor: Colors
  //                       .white, // Set the background color of the TextField
  //                   border: OutlineInputBorder(
  //                     borderSide:
  //                     BorderSide.none, // Remove border
  //                     borderRadius: BorderRadius.circular(
  //                         18), // Add border radius
  //                   ),
  //                   prefixIcon: IconButton(
  //                     onPressed: _onSearchIconPressed,
  //                     icon: Icon(Icons.search, size: 23),
  //                   ),
  //                   suffixIcon: IconButton(
  //                     onPressed: () {},
  //                     icon: Icon(Custom.equalizer, size: 18),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //               const EdgeInsets.symmetric(horizontal: 30.0),
  //               child: Row(
  //                 mainAxisAlignment:
  //                 MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CircleAvatar(
  //                         backgroundColor: Colors.transparent,
  //                         child: IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(
  //                               Icons.charging_station_sharp,
  //                               size: 28),
  //                         ),
  //                       ),
  //                       Text(
  //                         "Find",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                       Text(
  //                         "Charger",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => AddStationDetails(),
  //                               ));
  //                         },
  //                         child: CircleAvatar(
  //                           backgroundColor: Colors.transparent,
  //                           child: IconButton(
  //                             icon: Icon(Icons.add_location_alt_outlined, size: 28),
  //                             onPressed: () {},
  //                           ),
  //                         ),
  //                       ),
  //                       Text(
  //                         "Add",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                       Text(
  //                         "Charger",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CircleAvatar(
  //                         backgroundColor: Colors.transparent,
  //                         child: IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(Icons.route_outlined,
  //                               size: 28),
  //                         ),
  //                       ),
  //                       Text(
  //                         "Quick",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                       Text(
  //                         "Routes",
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Divider(
  //               color: Colors.black,
  //               height: 23,
  //               thickness: 2,
  //               indent: 25,
  //               endIndent: 25,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(24),
  //       topRight: Radius.circular(24),
  //     ),
  //   );
  //    await Future.delayed(const Duration(seconds: 5));
  //
  //   OverlayLoadingProgress.stop();
  // }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<ProviderClass>(context);
    if(currentLocation!=null){
      setState(() {
        locationData.currentLocationFetched=LatLng(currentLocation!.latitude!,
            currentLocation!.longitude!);
      });
    }
    final now = DateTime.now();
    String greeting = ''; // Default greeting

    if (now.hour >= 3 && now.hour < 12) {
      greeting = 'Good morning';
    } else if (now.hour >= 12 && now.hour < 16) {
      greeting = 'Good afternoon';
    } else if (now.hour >= 17 && now.hour < 21) {
      greeting = 'Good evening';
    } else {
      greeting = 'Good night';
    }

    List<Widget> IconList = [
      VehicleIcon(
        icon: Custom.motorcycle,
        vehicle_name: 'two wheeler',
        selectedIndex: 0,
      ),
      VehicleIcon(
        icon: Custom.car_side,
        vehicle_name: 'four wheeler',
        selectedIndex: 1,
      ),
      VehicleIcon(
        icon: Custom.truck,
        vehicle_name: 'heavy vehicle',
        selectedIndex: 2,
      )
    ];

    List<Widget> filterIconList = [
      FiltersIcon(
        filterName: 'Fast CCS2',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'Slow type 2',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'Slow 15A',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'Fast DC-001',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'fast CHAde',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'Slow IEC AC',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
      FiltersIcon(
        filterName: 'Fast type 6',
        initialColor: Colors.grey,
        onTapColor: Colors.redAccent,
      ),
    ];

    return WillPopScope(

      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to go back?'),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/chargePartnersLogo.png",
                    height: 37,
                    alignment: Alignment.bottomLeft,
                  ),
                  Flexible(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Charging stations',
                        filled: true,
                        fillColor: Colors
                            .white, // Set the background color of the TextField
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none, // Remove border
                          borderRadius:
                              BorderRadius.circular(18), // Add border radius
                        ),
                        prefixIcon: IconButton(
                          onPressed: _onSearchIconPressed,
                          icon: Icon(Icons.search, size: 23),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Custom.equalizer, size: 18),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_active, size: 21))
                ],
              ),
            ),
          ),
        ),
        body: currentLocation == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned.fill(
                    // child: ConstrainedBox(
                    //   constraints: BoxConstraints(
                    //     maxWidth: double.infinity, // Adjust this as needed
                    //     maxHeight: double.infinity, // Adjust this as needed
                    //   ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) async {
                        _customInfoWindowController.googleMapController =
                            controller;
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 15,
                      ),
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      markers: Set<Marker>.from(_otherMarkers),
                    ),
                    // ),
                  ),
                  Positioned(
                      top: 3,
                      left: 20,
                      child:
                      Consumer<ProviderClass>(
                        builder: (context, provider, _) {
                          return Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconList[provider.first],
                                      Container(
                                        height: 50,
                                        width: 300,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: filterIconList.map((iconWidget) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 10),
                                              child: iconWidget,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  IconList[provider.second],
                                  SizedBox(height: 5),
                                  IconList[provider.third],
                                  SizedBox(height: 5),
                                ],
                              ),
                            ],
                          );
                        },
                      )
                  ),
                  Positioned(
                    bottom: 75,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.green[700],
                      radius: 28,
                      child: IconButton(
                        onPressed: (){
                         Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context)=> AddStation())
                         );
                        },

                        icon: Icon(Icons.add_location_alt_outlined),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SlidingUpPanel(
                    onPanelClosed: (){
                      setState(() {
                        min_height_sliding = 0;
                      });
                    },
                    minHeight: min_height_sliding, // Minimum height of the panel
                    panel: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container( //for that scrollable showing
                          width: 40,
                          height: 5,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        Text(
                          '$greeting, Krupa.',
                          style: TextStyle(
                              color: GlobalColors.BottomNavIcon,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Charging stations',
                              filled: true,
                              fillColor: Colors
                                  .white, // Set the background color of the TextField
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none, // Remove border
                                borderRadius: BorderRadius.circular(
                                    18), // Add border radius
                              ),
                              prefixIcon: IconButton(
                                onPressed: _onSearchIconPressed,
                                icon: Icon(Icons.search, size: 23),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Custom.equalizer, size: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.charging_station_sharp,
                                          size: 28),
                                    ),
                                  ),
                                  Text(
                                    "Find",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Charger",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddStationDetails(),
                                          ));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: IconButton(
                                        icon: Icon(Icons.add_location_alt_outlined, size: 28),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Add",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Charger",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon:
                                          Icon(Icons.route_outlined, size: 28),
                                    ),
                                  ),
                                  Text(
                                    "Quick",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Routes",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 23,
                          thickness: 2,
                          indent: 25,
                          endIndent: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("Popular Community",style: TextStyle(fontSize: 24),),
                              Text("Coming soon...")
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 23,
                          thickness: 2,
                          indent: 25,
                          endIndent: 25,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("Latest updates",style: TextStyle(fontSize: 24),),
                              Text("Coming soon...")
                            ],
                          ),
                        )
                      ],
                    ),
                    collapsed: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                            Text(
                              '$greeting, Krupa.',
                              style: TextStyle(
                                  color: GlobalColors.BottomNavIcon,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Charging stations',
                                  filled: true,
                                  fillColor: Colors
                                      .white, // Set the background color of the TextField
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide.none, // Remove border
                                    borderRadius: BorderRadius.circular(
                                        18), // Add border radius
                                  ),
                                  prefixIcon: IconButton(
                                    onPressed: _onSearchIconPressed,
                                    icon: Icon(Icons.search, size: 23),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Custom.equalizer, size: 18),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.charging_station_sharp,
                                              size: 28),
                                        ),
                                      ),
                                      Text(
                                        "Find",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Charger",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddStationDetails(),
                                              ));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: IconButton(
                                            icon: Icon(Icons.add_location_alt_outlined, size: 28),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Add",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Charger",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.route_outlined,
                                              size: 28),
                                        ),
                                      ),
                                      Text(
                                        "Quick",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Routes",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              height: 23,
                              thickness: 2,
                              indent: 25,
                              endIndent: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),

                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 100, // Set an appropriate height
                    width: 200, // Set an appropriate width
                  ),
                ],
              ),
      ),
    );
  }
}

// scrollable list
// Container(
//   height: 50,
//   width: 300,
//   child: ListView(
//     scrollDirection: Axis.horizontal,
//     children: filterIconList.map((iconWidget) {
//       return Padding(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 10),
//         child: iconWidget,
//       );
//     }).toList(),
//   ),
// ),

//list of items
// IconList.map((iconWidget) {
//   return Padding(
//     padding:
//         const EdgeInsets.symmetric(vertical: 10.0),
//     child: iconWidget,
//   );
// }).toList(),

class MarkerDetailsPage extends StatelessWidget {
  final String title;
  final String snippet;
  double lat;
  double long;

  MarkerDetailsPage(
      {required this.title,
      required this.snippet,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Place name : "),
                Text(title),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Description : "),
                Text(snippet),
              ],
            ),
            ElevatedButton(
              onPressed: () => MapsLauncher.launchCoordinates(lat, long, title),
              child: Text('Redirect to map'),
            ),
          ],
        ),
      ),
    );
  }
}

// final IconList=[
//   twoWheeler(),
//   fourWheeler(),
//   HeavyVehicle(),
// ];

// List<Widget> IconList = [
//   VehicleIcon(
//     icon: Custom.motorcycle,
//     initialColor: Colors.grey,
//     onTapColor: Colors.cyanAccent,
//     vehicle_name: 'two wheeler',
//   ),
//   VehicleIcon(
//     icon: Custom.car_side,
//     initialColor: Colors.grey,
//     onTapColor: Colors.blueAccent,
//     vehicle_name: 'four wheeler',
//   ),
//   VehicleIcon(
//     icon: Custom.truck,
//     initialColor: Colors.grey,
//     onTapColor: Colors.orangeAccent,
//     vehicle_name: 'heavy vehicle',
//   )
// ];



// child: Row(
//   children: [
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             IconList[vehicletypeProvider.first],
//             Container(
//               height: 50,
//               width: 300,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: filterIconList.map((iconWidget) {
//                   return Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10),
//                     child: iconWidget,
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 5,),
//         IconList[vehicletypeProvider.second],
//         SizedBox(height: 5,),
//         IconList[vehicletypeProvider.third],
//         SizedBox(height: 5,),
//         ]
//     ),
//   ],
// ),

// List<Widget> filterIconList=[
//   FiltersIcon(
//     filterName: 'Fast CCS2',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'Slow type 2',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'Slow 15A',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'fast CHAde',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'Fast CCS2',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'Slow IEC AC',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
//   FiltersIcon(
//     filterName: 'Fast type 6',
//     initialColor: Colors.grey,
//     onTapColor: Colors.redAccent,
//     onTap: () {
//       print('vehicle type: ${vehicletypeProvider.vehicleType},');
//     },
//   ),
// ];


// SingleChildScrollView(
//   scrollDirection: Axis.horizontal,
//   physics: AlwaysScrollableScrollPhysics(),
//   child:
//   Row(
//     children: filterIconList.map((iconWidget) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: iconWidget,
//       );
//     }).toList(),
//   ),
// ),

// Container(
//
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     shrinkWrap: true,
//     itemCount: texts.length,
//     itemBuilder: (context, index) {
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Card(
//           child: Container(
//             height: 55,
//             width: 55,
//             child: Text(
//               texts[index],
//               style: TextStyle(fontSize: 12),
//             ),
//           ),
//         ),
//       );
//     },
//   ),
// ),
//

// Positioned(
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             Card(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIconIndex = 0; // Truck icon tapped
//                   });
//                 },
//                 child: Container(
//                   height: 55,
//                   width: 55,
//                   child: Icon(Custom.truck),
//                 ),
//               ),
//             ),
//             Container(
//               height: 60,
//               width: MediaQuery.of(context).size.width - 90,
//               child: SingleChildScrollView(
//                 physics: ScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 child: Visibility(
//                   visible: selectedIconIndex == 0,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     itemCount: texts.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           child: Container(
//                             height: 55,
//                             width: 55,
//                             child: Text(
//                               texts[index],
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Card(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIconIndex = 1; // Car icon tapped
//                   });
//                 },
//                 child: Container(
//                   height: 55,
//                   width: 55,
//                   child: Icon(Custom.car_side),
//                 ),
//               ),
//             ),
//             // Container(
//             //   height: 60,
//             //   width: MediaQuery.of(context).size.width - 90,
//             //   child: SingleChildScrollView(
//             //     physics: ScrollPhysics(),
//             //     scrollDirection: Axis.horizontal,
//             //     child: Visibility(
//             //       visible: selectedIconIndex == 1,
//             //       child: ListView.builder(
//             //         scrollDirection: Axis.horizontal,
//             //         shrinkWrap: true,
//             //         itemCount: texts.length,
//             //         itemBuilder: (context, index) {
//             //           return Padding(
//             //             padding: const EdgeInsets.all(8.0),
//             //             child: Card(
//             //               child: Container(
//             //                 height: 55,
//             //                 width: 55,
//             //                 child: Text(
//             //                   texts[index],
//             //                   style: TextStyle(fontSize: 12),
//             //                 ),
//             //               ),
//             //             ),
//             //           );
//             //         },
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//         Row(
//           children: [
//             Card(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIconIndex = 2; // Motorcycle icon tapped
//                   });
//                 },
//                 child: Container(
//                   height: 55,
//                   width: 55,
//                   child: Icon(Custom.motorcycle),
//                 ),
//               ),
//             ),
//             // Container(
//             //   height: 60,
//             //   width: MediaQuery.of(context).size.width - 90,
//             //   child: SingleChildScrollView(
//             //     physics: ScrollPhysics(),
//             //     scrollDirection: Axis.horizontal,
//             //     child: Visibility(
//             //       visible: selectedIconIndex == 2,
//             //       child: ListView.builder(
//             //         scrollDirection: Axis.horizontal,
//             //         shrinkWrap: true,
//             //         itemCount: texts.length,
//             //         itemBuilder: (context, index) {
//             //           return Padding(
//             //             padding: const EdgeInsets.all(8.0),
//             //             child: Card(
//             //               child: Container(
//             //                 height: 55,
//             //                 width: 55,
//             //                 child: Text(
//             //                   texts[index],
//             //                   style: TextStyle(fontSize: 12),
//             //                 ),
//             //               ),
//             //             ),
//             //           );
//             //         },
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),

// Positioned(
//     child: FutureBuilder(
//       future: getData(),
//       builder: (context,snapshot){
//         if(snapshot.connectionState==ConnectionState.waiting){
//           return CircularProgressIndicator();
//         }
//         else if(snapshot.hasError){
//           return Text(snapshot.error.toString());
//         }
//         else{
//           // return IconList[icon_selected_index];
//           return Column(
//             children: IconList,
//           );
//         }
//       },
//
//     ),
// ),

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
