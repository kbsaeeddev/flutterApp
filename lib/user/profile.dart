// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing3crud/user/mywallet.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var rating = 3.0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.hasData) {
              return Scaffold(
                body: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 20),
                          child: Card(
                            // color: Colors.red,
                            child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(vertical: 2),
                                leading: Icon(
                                  Icons.currency_rupee,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  'My Wallet',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                    'Your Current Coin Balance is : ${snapshot.data['coins']}'),
                                trailing: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyWallet()),
                                    );
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.red,
                                  ),
                                )
                                // onTap: () => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Profile()),
                                // ),
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 20),
                          child: Card(
                            // color: Colors.red,
                            child: ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 2),
                              leading: Icon(
                                Icons.person,
                                color: Colors.red,
                              ),
                              title: Text(
                                snapshot.data['name'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              // trailing: GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ChangeName(
                              //                 name: snapshot.data['name'],
                              //               )),
                              //     );
                              //   },
                              //   child: Icon(
                              //     Icons.arrow_forward_ios,
                              //     color: Colors.red,
                              //   ),
                              // )
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Profile()),
                              // ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 2),
                          child: Card(
                            // color: Colors.red,
                            child: ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 2),
                              leading: Icon(
                                Icons.email,
                                color: Colors.red,
                              ),
                              title: Text(
                                snapshot.data['email'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              // trailing: GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ChangeEmail(
                              //                 email: snapshot.data['email'],
                              //               )),
                              //     );
                              //   },
                              //   child: Icon(
                              //     Icons.arrow_forward_ios,
                              //     color: Colors.red,
                              //   ),
                              // )
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Profile()),
                              // ),
                            ),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 2),
                          child: Card(
                            // color: Colors.red,
                            child: ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 2),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.red,
                              ),
                              title: Text(
                                snapshot.data['phone'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              // trailing: GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ChangeEmail(
                              //                 email: snapshot.data['email'],
                              //               )),
                              //     );
                              //   },
                              //   child: Icon(
                              //     Icons.arrow_forward_ios,
                              //     color: Colors.red,
                              //   ),
                              // )
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Profile()),
                              // ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8.0, right: 8.0, top: 2),
                        //   child: Card(
                        //     // color: Colors.red,
                        //     child: ListTile(
                        //       dense: true,
                        //       visualDensity: const VisualDensity(vertical: 2),
                        //       leading: Icon(
                        //         Icons.lock,
                        //         color: Colors.red,
                        //       ),
                        //       title: const Text(
                        //         '*******',
                        //         style: TextStyle(
                        //           color: Colors.black87,
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //       // trailing: GestureDetector(
                        //       //   onTap: () {
                        //       //     Navigator.push(
                        //       //       context,
                        //       //       MaterialPageRoute(
                        //       //           builder: (context) =>
                        //       //               ChangePassword()),
                        //       //     );
                        //       //   },
                        //       //   child: Icon(
                        //       //     Icons.arrow_forward_ios,
                        //       //     color: Colors.red,
                        //       //   ),
                        //       // )

                        //       // onTap: () => Navigator.push(
                        //       //   context,
                        //       //   MaterialPageRoute(builder: (context) => Profile()),
                        //       // ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        });
 
 
  }
}

// Alert custom images
// _onAlertWithCustomImagePressed(context) {
//   Alert(
//     context: context,
//     title: "Review Submitted",
//     desc: "Thanks for your Feedback.",
//     image: Image.asset(
//       "check.gif",
//       width: 100,
//     ),
//   ).show();
// }