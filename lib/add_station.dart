import 'dart:async';
import 'package:cpdevuser/add_station_details.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'colors.dart';
import 'location_search.dart';


class AddStation extends StatefulWidget {
  const AddStation({super.key});

  @override
  State<AddStation> createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {

  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  TextEditingController _searchController = TextEditingController();
  late LatLng _defaultLatLng;
  late LatLng _draggedLatlng;
  String _draggedAddress = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    //set default latlng for camera position
    _defaultLatLng = LatLng(12,77);
    _draggedLatlng = _defaultLatLng;
    _cameraPosition = CameraPosition(
        target: _defaultLatLng,
        zoom: 17.5 // number of map view
    );

    //map will redirect to my current location when loaded
    _gotoUserCurrentPosition();
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15),),);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            shape: Border(bottom: BorderSide(width: 0.5)),
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
            title: Text(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                'Add Charge Station')),
        body: Column(
            children : [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30,left: 7, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: GlobalColors.Green,
                        maxRadius: 16,
                        child: Text(
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            '1'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        child: Text(
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400),
                            'Select Location'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 60,
                        height: 2,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: GlobalColors.Grey,
                          maxRadius: 16,
                          child: Text(
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              '2'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 60,
                        height: 2,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: GlobalColors.Grey,
                          maxRadius: 16,
                          child: Text(
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              '3'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 30, top: 20),
                child: Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Charging stations',
                      filled: true,
                      fillColor: Colors
                          .white, // Set the background color of the TextField
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5, color: GlobalColors.Grey),
                          borderRadius: BorderRadius.circular(5)),
                      suffixIcon: IconButton(
                        onPressed: () async{
                          var place = await LocationService().getPlace(_searchController.text);
                          _goToPlace(place);
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: h/2.7,
                width: w/1.1,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _cameraPosition!, //initialize camera position for map
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      onCameraIdle: () {
                        _getAddress(_draggedLatlng);
                      },
                      onCameraMove: (cameraPosition) {

                        _draggedLatlng = cameraPosition.target;
                      },
                      onMapCreated: (GoogleMapController controller) {
                        //this function will trigger when map is fully loaded
                        if (!_googleMapController.isCompleted) {
                          //set controller to google map when it is fully loaded
                          _googleMapController.complete(controller);
                        }
                      },
                    ),
                    Center(
                        child: Icon(
                          Icons.location_on_outlined,
                        )
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context)=> AddStationDetails()));
                     },
                    child: Container(
                      alignment: Alignment.center,
                      width: 83,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: GlobalColors.BtnGreen),
                      child: Text(
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: GlobalColors.white),
                          'Enter Details'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                  width: 300,
                  child: _showDraggedAddress())
              ,
            ]
        ),
      ),
    );
  }


  Widget _showDraggedAddress() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Center(child: Text(_draggedAddress, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)),
      ),
    );
  }

  //get address from dragged pin
  Future _getAddress(LatLng position) async {
    //this will list down all address around the position
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0]; // get only first and closest address
    String addresStr = "${address.name} ,${address.thoroughfare},${address.locality} , ${address.administrativeArea}, ${address.country},${address.postalCode}";
    setState(() {
      _draggedAddress = addresStr;
      print(placemarks);
      print('${position.latitude},${position.longitude}');
    });
  }

  //get user's current location and set the map's camera to that location
  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificPosition(LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  //go to specific position by latlng
  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: position,
            zoom: 17.5
        )
    ));
    //every time that we dragged pin , it will list down the address here
    await _getAddress(position);
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //check if user enable service for location permission
    if(!isLocationServiceEnabled) {
      print("user don't enable location permission");
    }

    locationPermission = await Geolocator.checkPermission();

    //check if user denied location and retry requesting for permission
    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission == LocationPermission.denied) {
        print("user denied location permission");
      }
    }

    //check if user denied permission forever
    if(locationPermission == LocationPermission.deniedForever) {
      print("user denied permission forever");
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

}



// import 'dart:async';
//
// import 'package:cpdevuser/colors.dart';
// import 'package:cpdevuser/location_search.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class AddStation extends StatefulWidget {
//   const AddStation({super.key});
//
//   @override
//   State<AddStation> createState() => _AddStationState();
// }
//
// class _AddStationState extends State<AddStation> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//   TextEditingController _searchController = TextEditingController();
//
//   CameraPosition? _cameraPosition;
//   late LatLng _defaultLatLng;
//   late LatLng _draggedLatlng;
//   late LatLng currentlocation;
//   String _draggedAddress = "";
//
//   //get address from dragged pin
//   Future _getAddress(LatLng position) async {
//     //this will list down all address around the position
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark address = placemarks[0]; // get only first and closest address
//     String addresStr = "${address.name} ,${address.thoroughfare},${address.locality} , ${address.administrativeArea}, ${address.country},${address.postalCode}";
//     setState(() {
//       _draggedAddress = addresStr;
//       print(placemarks);
//       print('${position.latitude},${position.longitude}');
//     });
//   }
//
//   //get user's current location and set the map's camera to that location
//   Future _gotoUserCurrentPosition() async {
//     Position currentPosition = await _determineUserCurrentPosition();
//     LatLng currentlocation=LatLng(currentPosition.latitude, currentPosition.longitude);
//     _gotoSpecificPosition(LatLng(currentPosition.latitude, currentPosition.longitude));
//   }
//
//   //go to specific position by latlng
//   Future _gotoSpecificPosition(LatLng position) async {
//     GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: position,
//             zoom: 17.5
//         )
//     ));
//     //every time that we dragged pin , it will list down the address here
//     await _getAddress(position);
//   }
//
//   Future _determineUserCurrentPosition() async {
//     LocationPermission locationPermission;
//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     //check if user enable service for location permission
//     if(!isLocationServiceEnabled) {
//       print("user don't enable location permission");
//     }
//
//     locationPermission = await Geolocator.checkPermission();
//
//     //check if user denied location and retry requesting for permission
//     if(locationPermission == LocationPermission.denied) {
//       locationPermission = await Geolocator.requestPermission();
//       if(locationPermission == LocationPermission.denied) {
//         print("user denied location permission");
//       }
//     }
//
//     //check if user denied permission forever
//     if(locationPermission == LocationPermission.deniedForever) {
//       print("user denied permission forever");
//     }
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//   }
//
//   @override
//   void initState() {
//     _defaultLatLng = currentlocation;
//     _draggedLatlng = _defaultLatLng;
//     _cameraPosition = CameraPosition(
//         target: _defaultLatLng,
//         zoom: 17.5 // number of map view
//     );
//
//     //map will redirect to my current location when loaded
//     _gotoUserCurrentPosition();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//             shape: Border(bottom: BorderSide(width: 0.5)),
//             leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
//             title: Text(
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 'Add Charge Station')),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 30,left: 7, bottom: 10),
//               child: Row(
//                 children: [
//                   Container(
//                     child: CircleAvatar(
//                       backgroundColor: GlobalColors.Green,
//                       maxRadius: 16,
//                       child: Text(
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w500),
//                           '1'),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5),
//                     child: Container(
//                       child: Text(
//                           style: TextStyle(
//                               fontSize: 10, fontWeight: FontWeight.w400),
//                           'Select Loction'),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Container(
//                       width: 60,
//                       height: 2,
//                       margin: EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Container(
//                       child: CircleAvatar(
//                         backgroundColor: GlobalColors.Grey,
//                         maxRadius: 16,
//                         child: Text(
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500),
//                             '2'),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Container(
//                       width: 60,
//                       height: 2,
//                       margin: EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Container(
//                       child: CircleAvatar(
//                         backgroundColor: GlobalColors.Grey,
//                         maxRadius: 16,
//                         child: Text(
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500),
//                             '3'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 20, right: 20, bottom: 30, top: 20),
//               child: Expanded(
//                 child: TextField(
//                   controller: _searchController,
//                   style: TextStyle(fontSize: 13),
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(left: 15),
//                     hintText: 'Charging stations',
//                     filled: true,
//                     fillColor: Colors
//                         .white, // Set the background color of the TextField
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             width: 0.5, color: GlobalColors.Grey),
//                         borderRadius: BorderRadius.circular(5)),
//                     suffixIcon: IconButton(
//                       onPressed: () async{
//                         var place = await LocationService().getPlace(_searchController.text);
//                         _goToPlace(place);
//                       },
//                       icon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Container(
//                 height: h / 2.5,
//                 child: Stack(
//                   children: [
//                   GoogleMap(
//                   initialCameraPosition: _cameraPosition!, //initialize camera position for map
//                   mapType: MapType.normal,
//                   myLocationEnabled: true,
//                   onCameraIdle: () {
//                     _getAddress(_draggedLatlng);
//                   },
//                   onCameraMove: (cameraPosition) {
//                     _draggedLatlng = cameraPosition.target;
//                   },
//                   onMapCreated: (GoogleMapController controller) {
//                     //this function will trigger when map is fully loaded
//                     if (!_controller.isCompleted) {
//                       //set controller to google map when it is fully loaded
//                       _controller.complete(controller);
//                     }
//                   },
//                 ),
//                     Center(
//                         child: Icon(
//                           Icons.location_on_outlined,
//                         )
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.only(top: 30, left: 20, right: 20),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     alignment: Alignment.center,
//                     width: 83,
//                     height: 34,
//                     // color: GlobalColors.Green,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: GlobalColors.Green),
//                     child: Text(
//                         style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                             color: GlobalColors.white),
//                         'Enter Details'),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> _goToPlace(Map<String, dynamic> place) async {
//     final double lat = place['geometry']['location']['lat'];
//     final double lng = place['geometry']['location']['lng'];
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15),),);
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'dart:async';
// //
// // import 'package:cpdevuser/colors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// //
// // class AddStation extends StatefulWidget {
// //   const AddStation({super.key});
// //
// //   @override
// //   State<AddStation> createState() => _AddStationState();
// // }
// //
// // class _AddStationState extends State<AddStation> {
// //   final Completer<GoogleMapController> _controller =
// //       Completer<GoogleMapController>();
// //   TextEditingController _searchController = TextEditingController();
// //   LocationData? currentLocation;
// //
// //   void getCurrentLocation() {
// //     Location location = Location();
// //
// //     location.getLocation().then((location) {
// //       setState(() {
// //         currentLocation = location;
// //       });
// //     });
// //   }
// //
// //   void centerMapToCurrentLocation() {
// //     if (_controller.isCompleted && currentLocation != null) {
// //       _controller.future.then((controller) {
// //         controller.animateCamera(
// //           CameraUpdate.newLatLng(
// //             LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
// //           ),
// //         );
// //       });
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     getCurrentLocation();
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     var h = MediaQuery.of(context).size.height;
// //     var w = MediaQuery.of(context).size.width;
// //     return SafeArea(
// //       child: Scaffold(
// //         resizeToAvoidBottomInset: false,
// //         appBar: AppBar(
// //             shape: Border(bottom: BorderSide(width: 0.5)),
// //             leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
// //             title: Text(
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //                 'Add Charge Station')),
// //         body: currentLocation == null
// //             ? Center(child: CircularProgressIndicator())
// //             : Column(
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.only(
// //                         top: 30, right: 20, left: 20, bottom: 10),
// //                     child: Row(
// //                       children: [
// //                         Container(
// //                           child: CircleAvatar(
// //                             backgroundColor: GlobalColors.Green,
// //                             maxRadius: 16,
// //                             child: Text(
// //                                 style: TextStyle(
// //                                     fontSize: 18, fontWeight: FontWeight.w500),
// //                                 '1'),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 5),
// //                           child: Container(
// //                             child: Text(
// //                                 style: TextStyle(
// //                                     fontSize: 10, fontWeight: FontWeight.w400),
// //                                 'Select Loction'),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Container(
// //                             width: 60,
// //                             height: 2,
// //                             margin: EdgeInsets.symmetric(vertical: 10),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Container(
// //                             child: CircleAvatar(
// //                               backgroundColor: GlobalColors.Grey,
// //                               maxRadius: 16,
// //                               child: Text(
// //                                   style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500),
// //                                   '2'),
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Container(
// //                             width: 60,
// //                             height: 2,
// //                             margin: EdgeInsets.symmetric(vertical: 10),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Container(
// //                             child: CircleAvatar(
// //                               backgroundColor: GlobalColors.Grey,
// //                               maxRadius: 16,
// //                               child: Text(
// //                                   style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500),
// //                                   '3'),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(
// //                         left: 20, right: 20, bottom: 30, top: 20),
// //                     child: Expanded(
// //                       child: TextField(
// //                         controller: _searchController,
// //                         obscureText: true,
// //                         style: TextStyle(fontSize: 13),
// //                         decoration: InputDecoration(
// //                           contentPadding: EdgeInsets.only(left: 15),
// //                           hintText: 'Charging stations',
// //                           filled: true,
// //                           fillColor: Colors
// //                               .white, // Set the background color of the TextField
// //                           border: OutlineInputBorder(
// //                               borderSide: BorderSide(
// //                                   width: 0.5, color: GlobalColors.Grey),
// //                               borderRadius: BorderRadius.circular(5)),
// //                           suffixIcon: IconButton(
// //                             onPressed: () {},
// //                             icon: Icon(Icons.search),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 20),
// //                     child: Container(
// //                       height: h / 2.5,
// //                       child: GoogleMap(
// //                         mapType: MapType.normal,
// //                         initialCameraPosition: CameraPosition(
// //                           target: LatLng(currentLocation!.latitude!,
// //                               currentLocation!.longitude!),
// //                           zoom: 15,
// //                         ),
// //                         onMapCreated: (GoogleMapController controller) {
// //                           _controller.complete(controller);
// //                         },
// //                         myLocationEnabled: true,
// //                       ),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding:
// //                         const EdgeInsets.only(top: 30, left: 20, right: 20),
// //                     child: Align(
// //                       alignment: Alignment.centerRight,
// //                       child: GestureDetector(
// //                         onTap: () {},
// //                         child: Container(
// //                           alignment: Alignment.center,
// //                           width: 83,
// //                           height: 34,
// //                           // color: GlobalColors.Green,
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(5),
// //                               color: GlobalColors.Green),
// //                           child: Text(
// //                               style: TextStyle(
// //                                   fontSize: 10,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: GlobalColors.white),
// //                               'Enter Details'),
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// // }
