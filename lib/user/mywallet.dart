// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing3crud/main.dart';
import 'package:testing3crud/user/homepage.dart';
import 'package:testing3crud/user/profile.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
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

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var rating = 3.0;
  File? pickedImage1;
  String imageUrl = 'No image to show';
  File? pickedImage2;
  bool isPicked1 = false;
  bool isPicked2 = false;
  bool _isLoading = false;
  var userCus = DateTime.now().toString();
  addUserOrderData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    // totalPrice = (int.parse(numberOfDays.text) * int.parse(numberOfRooms.text) * (singleRoomPrice + doubleRoomPrice + groupRoomPrice + familyRoomPrice)) + wifiPrice + beachPrice + gymPrice + parkingPrice + (int.parse(selectedCarPrice) * int.parse(selectedNumberOfCars));
    try {
      if (pickedImage1 == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog2(context),
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     // backgroundColor: ColorConstants.statusBarColor,
        //     content: const Text("Please upload verification image")));
        return;
      }
      print('print');
      print(pickedImage1);
      setState(() {
        _isLoading = true;
      });

      if ((pickedImage1.toString().contains('/'))) {
        var abc;
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersImages')
            .child(userCus + '.jpg');
        await ref.putFile(pickedImage1!);
        abc = await ref.getDownloadURL();
        setState(() {
          imageUrl = abc;
        });
      }
      print('Outside of image url');
      print(imageUrl);
      var userData =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      var docc = auth.currentUser!.uid;
      print(docc);
      var doccc = DateTime.now().toString();
      await firestore.collection('wallet').doc(doccc).set({
        "orderid": userCus,
        // "hotelImage": widget.productData.image,
        // "hotelId": hotelId,
        // "cityId": cityId,
        // "hotelName": widget.productData.name,
        "userId": auth.currentUser!.uid,
        "userName": userData.data()!['name'],
        "email": userData.data()!['email'],
        "name": name.text,
        "phone": phone.text,
        "description": description.text,
        "status": 'pending',
        "verify": imageUrl,
        "docId": docc,
        "dateTime": DateTime.now(),
        "walletId": doccc
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
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
      name.text = '';
      phone.text = '';
      description.text = '';
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



  Future getBankData() async {
    try {
      var bank = await FirebaseFirestore.instance
          .collection('coins')
          .doc('b7k5zP4Lxq6NZB8Akpl2')
          .get();
      return bank;
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
    return FutureBuilder(
        future: getBankData(),
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
        title: Text('My Wallet'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
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
                    'Account Details',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Chip(
            // elevation: 20,
            padding: EdgeInsets.all(8),
            backgroundColor: Colors.red[100],
            // shadowColor: Colors.black,
            // avatar: CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"), //NetworkImage
            // ), //CircleAvatar
            label: Text(
              '1 coin =${snapshot.data['value']} rupees',
              // style: TextStyle(fontSize: 20),
            ), //Text
          ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
              child: Card(
                child: ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: 2),
                  leading: Icon(
                    Icons.currency_rupee,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${snapshot.data['bank']}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('HBL'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Account Holder Name',
                  hintText: 'Enter Account Holder Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter Phone Number',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: description,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  hintText: 'Enter Description',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text("Add Screenshot"),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  // foreground
                ),
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    pickedImage1 = File(image.path);
                    print('image is ${pickedImage1}');
                    setState(() {
                      isPicked1 = true;
                    });
                  }
                },
                child: Text("Upload Image for Verification")),
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
                        width: MediaQuery.of(context).size.width,
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
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("SUBMIT")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
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
Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Request Submitted'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Your request for coins is now in pending mode until admin checks it."),
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
        child: const Text('Close'),
      ),
    ],
  );
}

Widget _buildPopupDialog2(BuildContext context) {
  return new AlertDialog(
    title: const Text('Alert'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Please upload verification image"),
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
