import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'dart:io';
import 'dart:math';

import 'colors.dart';

class OtpPage extends StatefulWidget {
  var phoneNum;

  OtpPage({Key? key,required this.phoneNum}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();
  var phonenumber;
  int ? otpValue;
  bool _codeSent = false;
  var DBotp;
  String? FCMtoken;

  Future<bool> checkPhoneNumberExists(String phonenumber) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phno', isEqualTo: phonenumber)
        .limit(1)
        .get();
    return querySnapshot.size > 0;
  }


  Future<void> UpdateLoginStatus(BuildContext context) async {
    phonenumber = widget.phoneNum.toString();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    late String deviceId;
    late String platformId;

    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      platformId = 'android';
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;
      platformId = 'ios';
    } else {
      deviceId = 'unknown';
      platformId = 'unknown';
    }


    bool isPhoneNumberExists = await checkPhoneNumberExists(phonenumber);
    if (isPhoneNumberExists) {
      CollectionReference data = FirebaseFirestore.instance.collection('Users');
      try {
        await data.doc(phonenumber).update({
          'logintime': DateTime.now(),
          'loginStatus': true,
          'activeStatus': true,
          'deleteStatus': false,
          'platformId': platformId,
          'deviceId': deviceId,
          'usertype': 'private',
          'FCM_Token':FCMtoken,
        });

        if (mounted) {
          print("User updated with login status in the database!");
          showSnackBar("User login successful!", Colors.grey);
        }
      } catch (error) {
        if (mounted) {
          print("Failed to update user: $error");
          showSnackBar("Failed to update user login status", Colors.grey);
        }
      }
    }
  }


  generateRandomOTP() {
    int min = 1000;
    int max = 9999;
    setState(() {
      otpValue = min + Random().nextInt(max - min + 1);
      _codeSent=true;
    });
    print("Sent OTP ${otpValue}");
    updateOTPInFirestore(otpValue!);
    // UpdateLoginStatus(context);
  }

  void updateOTPInFirestore(int newOTP) async {
    // Update the OTP in Firestore for the given phone number (phonenumber).
    await FirebaseFirestore.instance.collection('Users').doc(phonenumber).update({
      'otp': newOTP,
      // You can add other fields or update them as needed.
    });
  }



  void signInWithOTP() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(phonenumber)
        .get();

    if (!snapshot.exists) {
      showSnackBar('Document ID not found!', Colors.red);
      return;
    } else {
      var userData = snapshot.data();
      DBotp = userData?['otp'].toString();
    }

    if (DBotp == otpController.text) {
      // OTP Matches
      // Update login status, time, and other attributes in Firestore.
      UpdateLoginStatus(context);

      // Navigate to the next screen (e.g., WelcomePage).
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else {
      showSnackBar("Wrong OTP...", Colors.red);
    }
  }


  void showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  getFCMToken() async{
    FCMtoken = await messaging.getToken(
      vapidKey: " BANZ0vW63f4IhxRY8ukbSKQ4J_xBkAoAzuBcgrVjOLzITgUhNGWRCdUdb45TyDNoXOejcUuHoP-IpXCcxd6Q5As",
    );
  }
  @override
  void initState(){
    phonenumber = widget.phoneNum;
    getFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 66,
      height: 66,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor,width: 1.5),
      ),
    );

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: FractionalOffset.bottomLeft,
                    // alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: GlobalColors.OtpBox, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: IconButton(
                        alignment: Alignment.centerLeft,
                        iconSize: 15,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        'OTP Verification')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 50),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        'Enter the verification code we just send to your phone number ')),
              ),
              Pinput(
                controller: otpController,
                focusNode: focusNode,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 10),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 26,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            child: GestureDetector(
              onTap: () {
                signInWithOTP();
              },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    GlobalColors.BtnGreen,
                    Color.fromARGB(198, 20, 180, 130), // Adjusted color with darker values
                  ],
                  stops: [0.001, 1.0],
                ),
                boxShadow: [BoxShadow(blurRadius: 2)],
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              height: 60,
              width: w,
              child: Align(
                alignment: Alignment.center,
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                ),
          Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          "Didn't received code? "),
                      GestureDetector(
                        onTap: () {
                          generateRandomOTP();
                        },
                        child: Text(
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: GlobalColors.BtnGreen),
                            'Resend'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
//
// void signInWithOTP() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(phonenumber)
  //       .get();
  //
  //   if (!snapshot.exists) {
  //     showSnackBar('Document ID not found!', Colors.red);
  //     return;
  //   }
  //   else{
  //     var userData = snapshot.data();
  //     DBotp = userData?['otp'].toString();
  //   }
  //   if(DBotp == otpController.text){
  //     UpdateLoginStatus(context);
  //     // showSnackBar("OTP Matches...successful", GlobalColors.BtnGreen);
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => WelcomePage()),
  //     );
  //   }
  //   else{
  //     showSnackBar("Wrong OTP...", Colors.red);
  //   }
  //
  // }

// Future<void> UpdateLoginStatus(BuildContext context) async {
//   phonenumber = widget.phoneNum.toString();
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   AndroidDeviceInfo? androidInfo;
//   IosDeviceInfo? iosInfo;
//   late String deviceId;
//   late String platformId;
//
//   if (Platform.isAndroid) {
//     androidInfo = await deviceInfo.androidInfo;
//     deviceId = androidInfo.id;
//     platformId = 'android';
//   } else if (Platform.isIOS) {
//     iosInfo = await deviceInfo.iosInfo;
//     deviceId = iosInfo.identifierForVendor!;
//     platformId = 'ios';
//   } else {
//     deviceId = 'unknown';
//     platformId = 'unknown';
//   }
//
//   bool isPhoneNumberExists = await checkPhoneNumberExists(phonenumber);
//   if (isPhoneNumberExists) {
//     CollectionReference data = FirebaseFirestore.instance.collection('Users');
//     await data.doc(phonenumber).set({
//       'phno': phonenumber,
//       'otp': otpValue,
//       'logintime': DateTime.now(),
//       'loginStatus': true,
//       'activeStatus': true,
//       'deleteStatus': false,
//       'platformId': platformId,
//       'deviceId': deviceId,
//       'createdAt': FieldValue.serverTimestamp(),
//       'usertype': 'private',
//     })
//         .then((value) {
//       print("User updated with login status to the database!");
//       showSnackBar("User successfully added to the database!",Colors.grey);
//     }).catchError((error) {
//       print("Failed to add user");
//        showSnackBar("Failed to add user",Colors.red);
//     });
//   }
// }