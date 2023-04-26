import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Runner extends StatefulWidget {
  const Runner({Key? key}) : super(key: key);

  @override
  State<Runner> createState() => _RunnerState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _RunnerState extends State<Runner> {
  final Stream<QuerySnapshot> _userOrderStream = FirebaseFirestore.instance
      .collection("orders")
      // .where('userId', isEqualTo: '${auth.currentUser!.uid}')
      .where("isWinner", isEqualTo: false)
      .snapshots();
  TextEditingController coins = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: _userOrderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return snapshot.data!.docs.length == 0
                  ? Center(
                      child: Text('No pending request to show'),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          child: Column(
                            children: [
                              Divider(
                                height: 5,
                                thickness: 2,
                                indent: 0,
                                endIndent: 0,
                                color: Colors.black,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [

                                  Text('Name:'),
                                  Text(snapshot.data!.docs[index]['userName']),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [

                                  Text('Email:'),
                                  Text(snapshot.data!.docs[index]['email']),

                                ],
                              ),

                               SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [

                                  Text('Phone:'),
                                  Text(snapshot.data!.docs[index]['phone']),

                                ],
                              ),
                            ],
                          ),
                        );
                      });
            } else {
              return Center(
                child: Text('Nothing to show'),
              );
            }
          }
          return Center(
            child: Text('Error'),
          );
        });
  }
}
