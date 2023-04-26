import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DetailScreen extends StatelessWidget {
  final item;
  const DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    var data = item.data() as Map;
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
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
                    height: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(children: const [
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor: Colors.white,
                            // foregroundColor: Colors.red,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                              // backgroundImage: NetworkImage(
                              //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                              // ),
                              // backgroundImage:
                              //     AssetImage('assets/images/pic.png'),
                              radius: 60.0,
                            ),
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   right: 4,
                          //   child: CircleAvatar(
                          //     radius: 15,
                          //     // child: Icon(
                          //     //   Icons.edit,
                          //     //   size: 15,
                          //     // ),
                          //   ),
                          // )
                        ]),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data['email'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
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

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
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
                        data['name'],
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
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
                        data['email'],
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
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
                        data['phone'],
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
                  child: Card(
                    // color: Colors.red,
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 2),
                      leading: Icon(
                        Icons.lock,
                        color: Colors.red,
                      ),
                      title: const Text(
                        '*******',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      // trailing: GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               ChangePassword()),
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
              ],
            ),
          ),
        ),
      ),
    );
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