import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'colors.dart';
import 'otp_page.dart';

class PhoneVerify extends StatefulWidget {
  const PhoneVerify({Key? key}) : super(key: key);

  @override
  State<PhoneVerify> createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  late String completeNum = '';
  bool isPhoneNumberEntered = false;
  int ? otpValue;
  bool _codeSent = false;
  bool _isTimeout = false;
  String _errorMessage = '';
  var DBotp;

  Future<void> addUser(BuildContext context) async {
    String phnum = completeNum.toString();
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

    CollectionReference data = FirebaseFirestore.instance.collection('Users');
    await data.doc(phnum).set({
      'phno': phnum,
      'otp': otpValue,
      'loginStatus': false,
      'activeStatus': true,
      'deleteStatus': false,
      'platformId': platformId,
      'deviceId': deviceId,
      'createdAt': FieldValue.serverTimestamp(),
    })
        .then((value) {
      print("User successfully added to the database!");
      //showSnackBar("User successfully added to the database!",Colors.grey);
    }).catchError((error) {
      print("Failed to add user");
      // showSnackBar("Failed to add user",Colors.red);
    });
  }

  generateRandomOTP() {
    int min = 1000;
    int max = 9999;
    setState(() {
      otpValue = min + Random().nextInt(max - min + 1);
      _codeSent=true;
    });
    print("Sent OTP ${otpValue}");
    addUser(context);
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


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Enter Phone Number",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: h,
        width: w,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 20, 50, 0), // No spacing at the bottom
              child: Row(
                children: [
                  const SizedBox(width: 0),
                  Expanded(
                    child: IntlPhoneField(
                      showDropdownIcon: false,
                      controller: phoneNumberController,
                      flagsButtonPadding: const EdgeInsets.only(left: 10),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        setState(() {
                          completeNum = phone.completeNumber;
                          isPhoneNumberEntered = completeNum.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0), // Add spacing between phone field and text
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(style: TextStyle(fontSize: 18,),'We will send an SMS code \nto verify your number')
              ),
            ),

            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  if (isPhoneNumberEntered) {
                    generateRandomOTP();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpPage(phoneNum: completeNum)),
                    );
                  } else {
                    showSnackBar("Please enter a phone number", Colors.grey);
                  }

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
                      'Continue',
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
          ],
        ),
      ),
    );
  }
}