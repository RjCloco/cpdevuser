import 'package:flutter/material.dart';

import 'colors.dart';

class AddStationDetails extends StatefulWidget {
  const AddStationDetails({super.key});

  @override
  State<AddStationDetails> createState() => _AddStationDetailsState();
}

class _AddStationDetailsState extends State<AddStationDetails> {
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
        body: Container(
          height: h,
          width: w,
          child: Column(
            children: [
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              '3'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
