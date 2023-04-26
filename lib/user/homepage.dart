import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:testing3crud/admin/admindashboard.dart';
import 'package:intl/intl.dart';
import 'package:testing3crud/user/productscreen.dart';

import '../admin/detailscreen.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
//   DateTime dateToday = DateTime(DateTime.now().year) ;
// DateTime now = DateTime.now();
  final Query<Map<String, dynamic>> _products =
      FirebaseFirestore.instance.collection('products')
      // .where('endDate',
      //     isGreaterThanOrEqualTo: DateTime.now()
      //         .toString()
      //         .substring(0, 10)
      //         .replaceAll('-', '/')
      //         .split('/')
      //         .reversed
      //         .join('/')).where('endTime',
      //     isGreaterThanOrEqualTo: DateTime.now().toString().substring(10,16))
      ;
// todayDate() {
//     var now = new DateTime.now();
//     var formatter = new DateFormat('dd-MM-yyyy');
//     String formattedTime = DateFormat('kk:mm:a').format(now);
//     String formattedDate = formatter.format(now);
//     print(formattedTime);
//     print(formattedDate);
//   }

  @override
  Widget build(BuildContext context) {
// print(dateToday.toString().substring(0,10).replaceAll('-', '/').split('/').reversed.join('/')
//      );
// print(DateTime.now().toString().substring(10,16));
    return Scaffold(
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final item = streamSnapshot.data!.docs[index];
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductScreen(item: item, image: documentSnapshot['image'], )),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        visualDensity: VisualDensity(vertical: 2),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            // backgroundImage: NetworkImage(
                            //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                            // ),
                            backgroundImage:
                                NetworkImage(documentSnapshot['image']),
                            radius: 60.0,
                          ),
                        ),
                        title: Text(documentSnapshot['name']),
                        subtitle: Text(
                            'Coins: ' + documentSnapshot['coins'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(children: [
                            // IconButton(
                            //     onPressed: () => _update(documentSnapshot),
                            //     icon: Icon(Icons.edit)),
                            // IconButton(
                            //     onPressed: () => _delete(documentSnapshot.id),
                            //     icon: Icon(Icons.delete)),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('no data'),
            );
          },
        ),
      )
    ;
  }
}
