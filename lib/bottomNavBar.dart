import 'package:cpdevuser/colors.dart';
import 'package:cpdevuser/maps.dart';
import 'package:flutter/material.dart';

class navPage extends StatefulWidget {

  const navPage({Key? key}) : super(key: key);

  @override
  State<navPage> createState() => _navPageState();

}

class _navPageState extends State<navPage> {
  int selected_index=0;

  Future getData() async{
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return;
  }
  @override
  Widget build(BuildContext context) {
    final screens=[
      Map2(),
      Text('Under construction'),
      Text("Community"),
      Text('My Wallet'),
      Text('Profile'),
    ];
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            else{
              return screens[selected_index];
            }
          },

        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled,color: GlobalColors.BottomNavIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper,color: GlobalColors.BottomNavIcon),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group,color: GlobalColors.BottomNavIcon),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet,color: GlobalColors.BottomNavIcon),
            label: 'My Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded,color: GlobalColors.BottomNavIcon),
            label: 'Profile',
          ),
        ],
        onTap: (int index){
          setState(() {
            selected_index = index;
          });
        },
        currentIndex: selected_index,
      ),
    );

  }
}