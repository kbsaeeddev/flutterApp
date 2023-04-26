import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing3crud/admin/tickets/tickets.dart';
import 'package:testing3crud/admin/update.dart';
import 'package:testing3crud/admin/view.dart';
import 'package:testing3crud/auth/login_screen.dart';

import 'add.dart';
import 'coins.dart';
import 'payments/payments.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Admin Dashboard'),
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Container(
                      // padding: EdgeInsets.only(right: 24.0),
                      // decoration: new BoxDecoration(
                      //     border: new Border(
                      //         left: new BorderSide(
                      //             width: 2.0, color: Colors.red))),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ),
                  title: Text(
                    'Admin',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),

                  subtitle: Row(
                    children: <Widget>[
                      // Expanded(
                      //     flex: 1,
                      //     child: Container(
                      //       // tag: 'hero',
                      //       child: LinearProgressIndicator(
                      //           backgroundColor:
                      //               Color.fromRGBO(209, 224, 224, 0.2),
                      //           value: 3,
                      //           valueColor:
                      //               AlwaysStoppedAnimation(Colors.red)),
                      //     )),
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text('admin@gmail.com',
                                style: TextStyle(color: Colors.black))),
                      )
                    ],
                  ),
                  // trailing: Icon(Icons.keyboard_arrow_right,
                  //     color: Colors.white, size: 30.0),
                  // onTap: () {

                  //   Navigator.push(
                  //       context, MaterialPageRoute(builder: (context) => DetailPage()));
                  // },
                ),
                // abc
                ListTile(
                  leading: Icon(Icons.add_box),
                  title: Text('Add'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Add(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Update'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Update(),
                      ),
                    );
                  },
                ),
                                ListTile(
                  leading: Icon(Icons.token),
                  title: Text('Tickets'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Tickets(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Payments'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payments(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('View Users'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Payment Setting'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Coins(),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.settings),
                //   title: Text('Setting'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
