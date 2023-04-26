import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing3crud/admin/admindashboard.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  var deliveryData;
  String date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  File? pickedImage1;
  String imageUrl = 'No image to show';
  File? pickedImage2;
  bool isPicked1 = false;
  bool isPicked2 = false;
  bool _isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController desc = TextEditingController();

  void addData() {
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter name',
          style: TextStyle(color: Colors.white),
        ),
        // duration: Duration(seconds: 2),
      ));
      return;
    } else if (description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter coins',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (desc.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter description',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (pickedImage1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please upload image',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    sendData();
  }

  var userCus = DateTime.now().toString();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void sendData() async {
    try {
      print(pickedImage1);
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
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      String sHour = _selectedTime.hour.toString();
      String sMin = _selectedTime.minute.toString();
      if (_selectedTime.hour.toString().length == 1) {
        sHour = sHour.padLeft(2, '0');
      }
      if (_selectedTime.minute.toString().length == 1) {
        sMin = _selectedTime.minute.toString().padLeft(2, '0');
        print(sMin);
      }
      await firestore.collection('products').doc(userCus).set({
        "orderid": userCus,
        "name": name.text,
        "coins": description.text,
        "desc": desc.text,
        "image": imageUrl,
        "endDate":
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        // "pickUpTime": '${selectedPickUpTime.hour}:${selectedPickUpTime.minute}',
        "endHour": '${sHour}',
        "endMin": '${sMin}',
        "endTime": '${sHour}:${sMin}',
        "isActive": true
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
      setState(() {
        _isLoading = false;
      });
      name.text = '';
      description.text = '';
      desc.text = '';
      imageUrl = '';
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => AdminDashboard()),
      //     (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: Text("Your data is added")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: description,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Coins',
                  hintText: 'Set Coins',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: desc,
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
                child: Text("Upload Image")),
            Divider(
              height: 5,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Set Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 96,
                width: 380,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: const Text("Choose Date"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // time
            Divider(
              height: 5,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Set Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 96,
                width: 380,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          _selectTime(context);
                        },
                        child: const Text("Choose Time"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("${_selectedTime.format(context)}"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            // time end

            SizedBox(
              height: 20,
            ),

            Container(
              // width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: const BorderRadius.only(),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 5,
                //     blurRadius: 7,
                //     offset: const Offset(0, 3), // changes position of shadow
                //   ),
                // ],
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        "Are you sure you want to proceed?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.red),
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          addData();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("ADD")),
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2010),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: Colors.red,
      //         onPrimary: Colors.white,
      //         surface: Colors.white,
      //         background: Colors.white,
      //         // onSurface: Colors.yellow,
      //       ),
      //       dialogBackgroundColor: Colors.white,
      //     ),
      //     child: child,
      //   );
      // },
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        deliveryData =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Success'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Your request is successfully processed."),
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
