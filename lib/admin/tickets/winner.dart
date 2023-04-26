import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Winner extends StatefulWidget {
  const Winner({Key? key}) : super(key: key);

  @override
  State<Winner> createState() => _WinnerState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _WinnerState extends State<Winner> {
  final Stream<QuerySnapshot> _userOrderStream = FirebaseFirestore.instance
      .collection("orders")
      // .where('userId', isEqualTo: '${auth.currentUser!.uid}')
      .where("isWinner", isEqualTo: true)
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
                               Card(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: size.height * 0.30,
                                    margin: EdgeInsets.only(right: 50),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          snapshot.data!.docs[index]['productImage']),
                                      placeholder:
                                          const AssetImage('assets/loader.gif'),
                                      fit: BoxFit.cover,
                                     
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                              ),
                              SizedBox(
                                height: 2,
                              ),
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
                              
                               SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [

                                  Text('Product:'),
                                  Text(snapshot.data!.docs[index]['productName']),

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
