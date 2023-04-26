import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:testing3crud/admin/view.dart';
import 'package:testing3crud/main.dart';
import 'package:testing3crud/user/homepage.dart';
import 'package:testing3crud/user/profile.dart';

import '../admin/add.dart';
import '../auth/login_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int currentIndex = 0;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomePage2(),
    Profile(),
    // Camera page
    // Chats page
  ];

  // Number of tabs
  // final tabs = [
  //   HomePage(),
  //   Add()
  //   // Home(),
  //   // orderHistory(),
  //   // // Center(
  //   // //     child: PrimaryText(
  //   // //         text: 'Order History', size: 20, color: AppColors.primary)),
  //   // Profile(),
  //   // Center(
  //   //     child: PrimaryText(
  //   //         text: 'Cart detail Page', size: 40, color: AppColors.primary)),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('User'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Comment Icon',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
          // body: IndexedStack(
          //   index: currentIndex,
          //   children: _pages,
          // ),
          body: Container(
            // width: 30.0,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: _pages.elementAt(_selectedIndex), //New
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.red,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.60),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            // onTap: (value) {
            //   // Respond to item press.
            // },
            currentIndex: _selectedIndex, //New
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                // title: Text('Favorites'),
                label: 'Home',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.person_2),
              ),
            ],
          )),
    );
  }
}
