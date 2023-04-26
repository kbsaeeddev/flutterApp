import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProductScreen extends StatefulWidget {
  final String image;
  final item;
  const ProductScreen({super.key, required this.item, required this.image});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = false;

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

  addUserOrderData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // totalPrice = (int.parse(numberOfDays.text) * int.parse(numberOfRooms.text) * (singleRoomPrice + doubleRoomPrice + groupRoomPrice + familyRoomPrice)) + wifiPrice + beachPrice + gymPrice + parkingPrice + (int.parse(selectedCarPrice) * int.parse(selectedNumberOfCars));
    try {
      setState(() {
        _isLoading = true;
      });

      var userData =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      var data = widget.item.data() as Map;

      // print('coins');
      // print(userData.data()!['coins'].runtimeType);
      var productCoin = int.parse(data['coins']);
      // print('object');
      // print(productCoin.runtimeType);
      if (productCoin > userData.data()!['coins']) {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
        return;
      }

      var docc = auth.currentUser!.uid;
      print(docc);
      var doccc = docc + DateTime.now().toString();

      await firestore
          .collection('users')
          .doc(docc)
          .update({'coins': userData.data()!['coins'] - productCoin});

      await firestore.collection('orders').doc(doccc).set({
        "userId": auth.currentUser!.uid,
        "userName": userData.data()!['name'],
        "email": userData.data()!['email'],
        "phone": userData.data()!['phone'],
        "ticketId": doccc,
        "productCoins": productCoin,
        "productId": data['orderid'],
        "productName": data['name'],
        "productImage": data['image'],
        "productDate": data['endDate'],
        'orderDate': DateTime.now(),
        'isWinner': false,
      });
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text(
      //     '',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   duration: Duration(seconds: 2),
      // ));
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog2(context),
      );

      setState(() {
        _isLoading = false;
      });
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => HomePage2()),
      //     );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  var check = false;
  var productId;
  @override
  void initState() {
    super.initState();
    var data = widget.item.data() as Map;
    productId = data['productId'];
    print(data['isActive']);
    if (data['isActive'] == true) {
      print('ture hai');

      DateTime selectedDate = DateTime.now();
      TimeOfDay _selectedTime = TimeOfDay.now();

      var todayDate =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      var todayTime =
          "${_selectedTime.hour.toString()}:${_selectedTime.minute.toString()}";
      // Update the Firestore field when the widget is initialized
      // _updateFirestoreField();
      // print(todayDate);
      // print(data['endDate']);

      // print(todayTime);
      // print(data['endTime']);

      if ((int.parse(todayDate.split('/')[0]) >=
                  int.parse(data['endDate'].split('/')[0]) &&
              int.parse(todayDate.split('/')[1]) >=
                  int.parse(data['endDate'].split('/')[1]) &&
              int.parse(todayDate.split('/')[2]) >=
                  int.parse(data['endDate'].split('/')[2])) &&
          (int.parse(todayTime.split(':')[0]) >=
                  int.parse(data['endTime'].split(':')[0]) &&
              int.parse(todayTime.split(':')[1]) >=
                  int.parse(data['endTime'].split(':')[1]))) {
        // print('hello');
        checkwinner();
      check = true;
      } else {
        print('false hai');
      }
    }
    print('object');
  }

  // final Query<Map<String, dynamic>> _orders = FirebaseFirestore.instance
  //     .collection('orders')
  //     .where('isWinner', isEqualTo: '2023-04-07 09:29:50.897438');

  void checkwinner() async {
    {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var data = widget.item.data() as Map;

      print(data['orderid']);
      final Query<Map<String, dynamic>> winner = await firestore
          .collection('products')
          .where('productId', isEqualTo: data['orderid']);
      // var data1 = winner as Map;
      int count = await FirebaseFirestore.instance
          .collection('orders')
          .where('productId', isEqualTo: data['orderid'])
          .get()
          .then((value) => value.size);
      print(count);
      print('helllo');
      Random rnd;
      int min = 1;
      if (count == 0) {
        return;
      } else {
        int max = count;
        rnd = new Random();
        var r;
        r = min + rnd.nextInt(max - min);
        print("$r is in the range of $min and $max");

        var orderData = await FirebaseFirestore.instance
            .collection('orders')
            .where('productId', isEqualTo: data['orderid'])
            .get();
// Get the list of `QueryDocumentSnapshot` objects from the `_JsonQuerySnapshot`.
        List<QueryDocumentSnapshot> docs = orderData.docs;
        // print(docs[2]);
        var jsonSnapshot = docs[r - 1];
        Object? data3 = jsonSnapshot.data();
        var field1 = data3 as Map;
        print(field1['ticketId']);
// String? name = data3?['name'];
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(field1['ticketId'])
            .update({
          'isWinner': true,
        });

        var runnerStream = await FirebaseFirestore.instance
            .collection("orders")
            // .where('userId', isEqualTo: '${auth.currentUser!.uid}')
            .where("isWinner", isEqualTo: false)
            .where('productId', isEqualTo: productId)
            .get();
        List<QueryDocumentSnapshot> runner = runnerStream.docs;
        // print(runner);

        List<String> documentIdsToUpdate = [];
        if (runner != null) {
          for (var doc in runner) {
            Object? data = doc.data();
            var field1 = data as Map;

            documentIdsToUpdate.add(field1['userId']);
            //  FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(field2)
            //     .update({
            //   'coins': FieldValue.increment(int.parse(data['coins'])),
            // }).then((value) => value);

            // String field1 = data['field1'];
          }
        }
        print(documentIdsToUpdate);
        documentIdsToUpdate.forEach((item) async {
          final QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('userId', isEqualTo: item)
              .get();

          snapshot.docs.forEach((doc) {
            FirebaseFirestore.instance.collection('users').doc(doc.id).update({
              'coins': FieldValue.increment(int.parse(data['coins'])),
            });
          });
        });

        print('productId');

        print(data['orderid']);
        await FirebaseFirestore.instance
            .collection('products')
            .doc(data['orderid'])
            .update({
          'isActive': false,
        });

// Iterate over each `QueryDocumentSnapshot` to read the data.
        // for (var doc in docs) {
        //   // Access the data in the document as a `Map<String, dynamic>`.
        //   Object? data = doc.data();
        //   // Access individual fields by their names.
        //   // String field1 = data['field1'];
        //   // int field2 = data['field2'];

        //   // Do something with the data...
        // }

        // print(orderData);
      }
    }
  }
  //       final Stream<QuerySnapshot> _userOrderStream = FirebaseFirestore.instance
  // .collection("orders")
  // // .where('userId', isEqualTo: '${auth.currentUser!.uid}')
  // .where("isWinner", isEqualTo: false)
  // .where('productId', isEqualTo: productId)
  // .snapshots();

  Future getWinnerData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      print(productId);
      var users = await FirebaseFirestore.instance
          .collection('orders')
          .where("isWinner", isEqualTo: false)
          .where('productId', isEqualTo: productId)
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

  @override
  Widget build(BuildContext context) {
    var data = widget.item.data() as Map;
    String imageUrl = data['image'];
    // print(data['image']);
    if (check || data['isActive'] == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Product"),
          backgroundColor: Colors.red,
        ),
        body: Center(child: Text('Times up for this qurandazie')),
      );
      // body: StreamBuilder(
      //   stream: _orders.snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      //     if (streamSnapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: streamSnapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           final DocumentSnapshot documentSnapshot =
      //               streamSnapshot.data!.docs[index];
      //           return Card(
      //             margin: EdgeInsets.all(10),
      //             child: ListTile(
      //               title: Text(documentSnapshot['email']),
      //               subtitle: Text(
      //                   'Coins: ' + documentSnapshot['email'].toString()),
      //               trailing: SizedBox(
      //                 width: 100,
      //                 child: Row(children: []),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     return const Center(
      //       child: Text('no data'),
      //     );
      //   },
      // ),

      //   return FutureBuilder(
      //   future: getWinnerData(),
      //   builder: (BuildContext ctx, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasError) {
      //         return const Center(
      //           child: Text('Something went wrong'),
      //         );
      //       }
      //       if (snapshot.hasData) {
      //         return Scaffold(
      //           body: SizedBox(
      //             child: SingleChildScrollView(
      //               child: Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 8.0, right: 8.0, top: 20),
      //                     child: Card(
      //                       // color: Colors.red,
      //                       child: ListTile(
      //                           dense: true,
      //                           visualDensity: const VisualDensity(vertical: 2),
      //                           leading: Icon(
      //                             Icons.currency_rupee,
      //                             color: Colors.red,
      //                           ),
      //                           title: Text(
      //                             'My Wallet',
      //                             style: const TextStyle(
      //                               color: Colors.black87,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           subtitle: Text(
      //                               'Your Current Coin Balance is : ${snapshot.data['email']}'),
      //                           trailing: GestureDetector(
      //                             onTap: () {
      //                               // Navigator.push(
      //                               //   context,
      //                               //   MaterialPageRoute(
      //                               //       builder: (context) => MyWallet()),
      //                               // );
      //                             },
      //                             child: Icon(
      //                               Icons.arrow_forward_ios,
      //                               color: Colors.red,
      //                             ),
      //                           )
      //                           // onTap: () => Navigator.push(
      //                           //   context,
      //                           //   MaterialPageRoute(builder: (context) => Profile()),
      //                           // ),
      //                           ),
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 8.0, right: 8.0, top: 20),
      //                     child: Card(
      //                       // color: Colors.red,
      //                       child: ListTile(
      //                         dense: true,
      //                         visualDensity: const VisualDensity(vertical: 2),
      //                         leading: Icon(
      //                           Icons.person,
      //                           color: Colors.red,
      //                         ),
      //                         title: Text(
      //                           snapshot.data['email'],
      //                           style: const TextStyle(
      //                             color: Colors.black87,
      //                             fontSize: 20,
      //                           ),
      //                         ),
      //                         // trailing: GestureDetector(
      //                         //   onTap: () {
      //                         //     Navigator.push(
      //                         //       context,
      //                         //       MaterialPageRoute(
      //                         //           builder: (context) => ChangeName(
      //                         //                 name: snapshot.data['name'],
      //                         //               )),
      //                         //     );
      //                         //   },
      //                         //   child: Icon(
      //                         //     Icons.arrow_forward_ios,
      //                         //     color: Colors.red,
      //                         //   ),
      //                         // )
      //                         // onTap: () => Navigator.push(
      //                         //   context,
      //                         //   MaterialPageRoute(builder: (context) => Profile()),
      //                         // ),
      //                       ),
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 8.0, right: 8.0, top: 2),
      //                     child: Card(
      //                       // color: Colors.red,
      //                       child: ListTile(
      //                         dense: true,
      //                         visualDensity: const VisualDensity(vertical: 2),
      //                         leading: Icon(
      //                           Icons.email,
      //                           color: Colors.red,
      //                         ),
      //                         title: Text(
      //                           snapshot.data['email'],
      //                           style: const TextStyle(
      //                             color: Colors.black87,
      //                             fontSize: 20,
      //                           ),
      //                         ),
      //                         // trailing: GestureDetector(
      //                         //   onTap: () {
      //                         //     Navigator.push(
      //                         //       context,
      //                         //       MaterialPageRoute(
      //                         //           builder: (context) => ChangeEmail(
      //                         //                 email: snapshot.data['email'],
      //                         //               )),
      //                         //     );
      //                         //   },
      //                         //   child: Icon(
      //                         //     Icons.arrow_forward_ios,
      //                         //     color: Colors.red,
      //                         //   ),
      //                         // )
      //                         // onTap: () => Navigator.push(
      //                         //   context,
      //                         //   MaterialPageRoute(builder: (context) => Profile()),
      //                         // ),
      //                       ),
      //                     ),
      //                   ),
      //                    Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 8.0, right: 8.0, top: 2),
      //                     child: Card(
      //                       // color: Colors.red,
      //                       child: ListTile(
      //                         dense: true,
      //                         visualDensity: const VisualDensity(vertical: 2),
      //                         leading: Icon(
      //                           Icons.phone,
      //                           color: Colors.red,
      //                         ),
      //                         title: Text(
      //                           snapshot.data['email'],
      //                           style: const TextStyle(
      //                             color: Colors.black87,
      //                             fontSize: 20,
      //                           ),
      //                         ),
      //                         // trailing: GestureDetector(
      //                         //   onTap: () {
      //                         //     Navigator.push(
      //                         //       context,
      //                         //       MaterialPageRoute(
      //                         //           builder: (context) => ChangeEmail(
      //                         //                 email: snapshot.data['email'],
      //                         //               )),
      //                         //     );
      //                         //   },
      //                         //   child: Icon(
      //                         //     Icons.arrow_forward_ios,
      //                         //     color: Colors.red,
      //                         //   ),
      //                         // )
      //                         // onTap: () => Navigator.push(
      //                         //   context,
      //                         //   MaterialPageRoute(builder: (context) => Profile()),
      //                         // ),
      //                       ),
      //                     ),
      //                   ),
      //                   // Padding(
      //                   //   padding: const EdgeInsets.only(
      //                   //       left: 8.0, right: 8.0, top: 2),
      //                   //   child: Card(
      //                   //     // color: Colors.red,
      //                   //     child: ListTile(
      //                   //       dense: true,
      //                   //       visualDensity: const VisualDensity(vertical: 2),
      //                   //       leading: Icon(
      //                   //         Icons.lock,
      //                   //         color: Colors.red,
      //                   //       ),
      //                   //       title: const Text(
      //                   //         '*******',
      //                   //         style: TextStyle(
      //                   //           color: Colors.black87,
      //                   //           fontSize: 20,
      //                   //         ),
      //                   //       ),
      //                   //       // trailing: GestureDetector(
      //                   //       //   onTap: () {
      //                   //       //     Navigator.push(
      //                   //       //       context,
      //                   //       //       MaterialPageRoute(
      //                   //       //           builder: (context) =>
      //                   //       //               ChangePassword()),
      //                   //       //     );
      //                   //       //   },
      //                   //       //   child: Icon(
      //                   //       //     Icons.arrow_forward_ios,
      //                   //       //     color: Colors.red,
      //                   //       //   ),
      //                   //       // )

      //                   //       // onTap: () => Navigator.push(
      //                   //       //   context,
      //                   //       //   MaterialPageRoute(builder: (context) => Profile()),
      //                   //       // ),
      //                   //     ),
      //                   //   ),
      //                   // ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         );
      //       }
      //     }
      //     return const Center(
      //       child: Text('Something went wrong'),
      //     );
      //   }

      // );
    } else {
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
                  appBar: AppBar(
                    title: Text('Product'),
                    backgroundColor: Colors.red,
                  ),
                  body: SizedBox(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              child: SizedBox(
                                width: double.infinity,
                                height: 480.0,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'You have  ${snapshot.data['coins']} coins',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: 300.0,
                                      width: 300.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.fill,
                                        ),
                                        // shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 5,
                                            thickness: 2,
                                            indent: 10,
                                            endIndent: 10,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Win a ${data['name']}',
                                            style: TextStyle(
                                                fontSize: 32.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Ending at ${data['endDate']} ${data['endTime']}',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'You need only ${data['coins']} coins',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Text("Rate Us"),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Divider(
                              height: 5,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                              color: Colors.red,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            onPressed: () async {
                                              await addUserOrderData();

                                              // await ScaffoldMessenger.of(context)
                                              //     .showSnackBar(SnackBar(
                                              //         // backgroundColor: ColorConstants.statusBarColor,
                                              //         content: const Text(
                                              //             "")));
                                              //  await Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => const Profile()),
                                              //   );
                                            },
                                            child: _isLoading
                                                ? const Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text("BUY A TICKET")),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}

// class DetailScreen extends StatelessWidget {
// final Item item;

// DetailScreen({required this.item});

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(item.title),
//     ),
//     body: Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.network(item.imageUrl),
//           Text(item.title),
//           Text(item.subtitle),
//         ],
//       ),
//     ),
//   );

// }

// }

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Alert'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("You do not have enough coins"),
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        child: const Text('Ok'),
      ),
    ],
  );
}

Widget _buildPopupDialog2(BuildContext context) {
  return new AlertDialog(
    title: const Text('Success'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("You have purchase the ticket"),
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        child: const Text('Ok'),
      ),
    ],
  );
}
