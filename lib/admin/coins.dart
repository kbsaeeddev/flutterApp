import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Coins extends StatefulWidget {
  const Coins({super.key});

  @override
  State<Coins> createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  var deliveryData;
  String date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('coins');
  // await _product.add({"name": name, "price": price});
  // await _product.update({"name": name, "price": price});
  // await _product.doc(productId).delete();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['value'];
      _bankController.text = documentSnapshot['bank'];
      _descController.text = documentSnapshot['description'];
      // _quantityController.text = documentSnapshot['coins'].toString();
      // _descController.text = documentSnapshot['desc'].toString();
      // _dateController.text = documentSnapshot['endDate'].toString();
      // _timeController.text = documentSnapshot['endTime'].toString();
    }

    // modal
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          labelText: 'Update Coin Value',
                          suffixIcon: Icon(Icons.currency_rupee)),
                    ),
                    TextField(
                      controller: _bankController,
                      decoration: InputDecoration(
                          labelText: 'Update Account Number',
                          suffixIcon: Icon(Icons.numbers)),
                    ),
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                          labelText: 'Update Account Details',
                          suffixIcon: Icon(Icons.description)),
                    ),
                    // TextField(
                    //   controller: _quantityController,
                    //   keyboardType:
                    //       TextInputType.numberWithOptions(decimal: true),
                    //   decoration: InputDecoration(labelText: 'Coins'),
                    // ),
                    // TextField(
                    //   controller: _descController,
                    //   decoration: InputDecoration(labelText: 'Description'),
                    // ),
                    // TextField(
                    //   controller: _dateController,
                    //   decoration: InputDecoration(labelText: 'Date'),
                    // ),
                    // TextField(
                    //   controller: _timeController,
                    //   decoration: InputDecoration(labelText: 'Time (24 hours format)'),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () async {
                          final String val = _nameController.text;
                          final String bank = _bankController.text;
                          final String desc = _descController.text;
                          // final String quantity = _quantityController.text;
                          // final String desc = _descController.text;
                          // final String date = _dateController.text;
                          // final String time = _timeController.text;
                          // if (quantity) {
                          await _products.doc(documentSnapshot!.id).update({
                            'value': val,
                            'bank': bank,
                            'description': desc,
                            'updatedAt': '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          });
                          _nameController.text = '';
                          _bankController.text = '';
                          _descController.text = '';
                          // }
                        },
                        child: Text('Update'))
                  ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.red,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text("Payment Setting"),
          backgroundColor: Colors.red,
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Column(
                    children: [
                      Card(
                        color: Colors.red,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.date_range),
                          ),
                          title: Text(
                            'Last Updated At ' +
                                documentSnapshot['updatedAt'] +
                                '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.currency_rupee),
                          ),
                          title: Text('Account Number : ${documentSnapshot['bank']} ${documentSnapshot['description']}'),
                          subtitle: Text('1 coin is equal to ' +
                              documentSnapshot['value'] +
                              ' rupees'),
                          // subtitle: Text(
                          //     'Coins: ' + documentSnapshot['coins'].toString()),
                          trailing: SizedBox(
                            width: 50,
                            child: Row(children: [
                              IconButton(
                                  onPressed: () => _update(documentSnapshot),
                                  icon: Icon(Icons.edit)),
                              // IconButton(
                              //     onPressed: () => _delete(documentSnapshot.id),
                              //     icon: Icon(Icons.delete)),
                            ]),
                          ),
                        ),
                      ),
                    ],
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
