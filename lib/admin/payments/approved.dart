import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryApproved extends StatefulWidget {
  const OrderHistoryApproved({Key? key}) : super(key: key);

  @override
  State<OrderHistoryApproved> createState() => _OrderHistoryApprovedState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _OrderHistoryApprovedState extends State<OrderHistoryApproved> {
  final Stream<QuerySnapshot> _userOrderStream = FirebaseFirestore.instance
      .collection("wallet")
      // .where('userId', isEqualTo: '${auth.currentUser!.uid}')
      .where("status", isEqualTo: 'approved')
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
                              Card(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Container(
                                      height: size.height * 0.30,
                                      // margin: EdgeInsets.only(right: 50),
                                      child: FadeInImage(
                                        image: NetworkImage(
                                            snapshot.data!.docs[index]['verify']),
                                        placeholder:
                                            const AssetImage('assets/loader.gif'),
                                        fit: BoxFit.contain,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset('assets/loader.gif',
                                              fit: BoxFit.fitWidth);
                                        },
                                      ),
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
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                   Expanded(
                                    child: Text(
                                        'Status',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 22),
                                      ),
                                      
                                  ),
                                  Expanded(
                                    child: Chip(
                                      label: const Text(
                                        'Approved',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14),
                                      ),
                                      backgroundColor: Colors.blue[100],
                                    ),
                                  ),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       primary: Colors.red, // background
                                  //       // foreground
                                  //     ),
                                  //     onPressed: () {
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) =>
                                  //             new AlertDialog(
                                  //           title: const Text('Approving'),
                                  //           content: new Column(
                                  //             mainAxisSize: MainAxisSize.min,
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: <Widget>[
                                  //               Padding(
                                  //                 padding: EdgeInsets.all(0),
                                  //                 child: TextField(
                                  //                   controller: coins,
                                  //                   keyboardType: TextInputType
                                  //                       .numberWithOptions(
                                  //                           decimal: true),
                                  //                   decoration: InputDecoration(
                                  //                     border:
                                  //                         OutlineInputBorder(),
                                  //                     labelText: 'Coins',
                                  //                     hintText: 'Enter Coins',
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               //     Text(
                                  //               //         snapshot.data!.docs[index]
                                  //               // ['email']),
                                  //             ],
                                  //           ),
                                  //           actions: <Widget>[
                                  //             ElevatedButton(
                                  //               onPressed: () {
                                  //                 var docu = snapshot.data!
                                  //                     .docs[index]['userId'];
                                  //                 var pre = FirebaseFirestore
                                  //                     .instance
                                  //                     .collection("users")
                                  //                     .doc(docu)
                                  //                     .get();

                                  //                 print('object');
                                  //                 print(pre);
                                  //                 FirebaseFirestore.instance
                                  //                     .collection("users")
                                  //                     .doc(docu)
                                  //                     .update({
                                  //                   'coins':
                                  //                       FieldValue.increment(
                                  //                           int.parse(
                                  //                               coins.text)),
                                  //                 }).then((value) {
                                  //                   // Navigator.pop(context);
                                  //                 });

                                  //                 var walletId = snapshot.data!
                                  //                     .docs[index]['walletId'];
                                  //                 // var docuu = docc.docs;

                                  //                 FirebaseFirestore.instance
                                  //                     .collection("wallet")
                                  //                     .doc(walletId)
                                  //                     .update({
                                  //                   'status': 'approved',
                                  //                 }).then((value) {
                                  //                   Navigator.pop(context);
                                  //                 });
                                  //                 coins.text = '';
                                  //               },
                                  //               style: ElevatedButton.styleFrom(
                                  //                 primary: Colors.red,
                                  //               ),
                                  //               child: const Text('Approved'),
                                  //             ),
                                  //             ElevatedButton(
                                  //               onPressed: () {
                                  //                 Navigator.of(context).pop();
                                  //               },
                                  //               style: ElevatedButton.styleFrom(
                                  //                 primary: Colors.red,
                                  //               ),
                                  //               child: const Text('Close'),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //       var docu =
                                  //           snapshot.data!.docs[index]['email'];
                                  //       // var docuu = docc.docs;

                                  //       // FirebaseFirestore.instance
                                  //       //     .collection("wallet")
                                  //       //     .doc(docu)
                                  //       //     .update({
                                  //       //   'status': 'cancelled',
                                  //       // }).then((value) {
                                  //       //   // Navigator.pop(context);
                                  //       // });
                                  //     },
                                  //     child: Text("Approve")),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       primary: Colors.red, // background
                                  //       // foreground
                                  //     ),
                                  //     onPressed: () {
                                  //       var docu = snapshot.data!.docs[index]
                                  //           ['orderid'];
                                  //       // var docuu = docc.docs;

                                  //       FirebaseFirestore.instance
                                  //           .collection("usersOrder")
                                  //           .doc(docu)
                                  //           .update({
                                  //         'status': 'cancelled',
                                  //       }).then((value) {
                                  //         // Navigator.pop(context);
                                  //       });
                                  //     },
                                  //     child: Text("Reject"))
                                 
                                  // Expanded(
                                  //   child: Chip(
                                  //     label: const Text(
                                  //       'Pending',
                                  //       style: TextStyle(
                                  //           color: Colors.black87,
                                  //           fontSize: 14),
                                  //     ),
                                  //     backgroundColor: Colors.blue[100],
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
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
