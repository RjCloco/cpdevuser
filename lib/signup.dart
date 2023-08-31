import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpdevuser/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:intl_phone_field/intl_phone_field.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phno = TextEditingController();
  TextEditingController otp = TextEditingController();
  var completeNum;

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign up status"),
      content: Row(
        children: [
          Text("Sign Up successful "),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
      'otp': otp.toString().trim(),
      'logintime': DateTime.now(),
      'loginStatus': true,
      'activeStatus': true,
      'deleteStatus': false,
      'platformId': platformId,
      'deviceId': deviceId,
      'createdAt': FieldValue.serverTimestamp(),
    })
        .then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('User successfully added to the database!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add user: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
        body:Container(
          height: h,
          width: w,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60,),
                      IntlPhoneField(
                        controller: phno,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          completeNum = phone.completeNumber;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: otp,
                          decoration: InputDecoration(
                            labelText: "OTP",
                            hintText: "Enter OTP",
                            prefixIcon: Icon(Icons.lock_rounded,color: Colors.blue.shade400),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter OTP';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                addUser(context);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}



