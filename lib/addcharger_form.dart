import 'package:camera/camera.dart';
import 'package:cpdevuser/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'camera.dart';
import 'colors.dart';

class AddStationDetails extends StatefulWidget {
  const AddStationDetails({super.key});

  @override
  State<AddStationDetails> createState() => _AddStationDetailsState();
}

class _AddStationDetailsState extends State<AddStationDetails> {
  final formKey = GlobalKey<FormState>();
  TextEditingController chargingStationName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController opensAt = TextEditingController();
  TextEditingController closesAt = TextEditingController();
  TextEditingController amenities = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController additionalNotes = TextEditingController();
  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> paymentMethods = [
    'Cash',
    'PhonePe',
    'Google Pay',
    'Paytm',
    'Amazon Pay',
    'UPI',
    'Credit Card',
    'Debit Card',
  ];
  List<String> chargerTypes = [
    'CCS2 (Fast)',
    'Type 2',
    'Slow AC',
    'ChaDeMo',
    'AC001',
    'DC001',
    '15A Wall',
    'AtherGrid',
  ];
  List<String> selectedMethods = [];

  XFile? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _photo = XFile(pickedFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreviewPage(picture: _photo)),
        );
        // uploadAndSaveToFirestore();
      } else {
        print('No image selected');
      }
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: this.context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                tileColor: Colors.orangeAccent,
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload Photo from Files'),
                onTap: () {
                  imgFromGallery(context);
                },
              ),
              ListTile(
                tileColor: Colors.orangeAccent,
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Upload Photo via Camera'),
                onTap: () async {
                  await availableCameras().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CameraPage(cameras: value)),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 7, bottom: 10),
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
                          backgroundColor: GlobalColors.Green,
                          maxRadius: 16,
                          child: Text(
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              '2'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        child: Text(
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400),
                            'Enter details'),
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
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              '3'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: chargingStationName,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp(r'[a-zA-Z ]'),
                                  allow: true)
                            ],
                            decoration: InputDecoration(
                              labelText: "Charging Station Name",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.blueAccent),
                                // borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: chargingStationName,
                            readOnly: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            width: 1,
                                            color: GlobalColors.Grey)),
                                    child: Icon(size: 40, Icons.image_outlined),
                                  ),
                                ),
                              ),
                              labelText: "Attach images",
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.blueAccent),
                                // borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: chargingStationName,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp(r'[a-zA-Z ]'),
                                  allow: true)
                            ],
                            decoration: InputDecoration(
                              labelText: "Address",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.blueAccent),
                                // borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: ListTile(
                            title: Text('Open 24x7'),
                            leading: Checkbox(
                                value: false, onChanged: (bool? value) {}),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Select Payment Methods:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(paymentMethods[index]),
                              leading: Checkbox(
                                value: false, // Set the initial checkbox state
                                onChanged: (bool? value) {
                                  setState(() {
                                    isSelected[index] = value ?? false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        Text(
                          'Select Supported Charger Types',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: chargerTypes.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(chargerTypes[index]),
                              leading: Checkbox(
                                value: false, // Set the initial checkbox state
                                onChanged: (bool? value) {
                                  setState(() {
                                    isSelected[index] = value ?? false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    if (isSelected[i]) {
                                      selectedMethods.add(paymentMethods[i]);
                                    }
                                  }
                                  print(
                                      'Selected Payment Methods: $selectedMethods');
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: PaymentMethodForm()
// ),
