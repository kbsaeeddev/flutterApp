import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  var deliveryData;
  String date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  // await _product.add({"name": name, "price": price});
  // await _product.update({"name": name, "price": price});
  // await _product.doc(productId).delete();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _quantityController.text = documentSnapshot['coins'].toString();
      _descController.text = documentSnapshot['desc'].toString();
      _dateController.text = documentSnapshot['endDate'].toString();
      _timeController.text = documentSnapshot['endTime'].toString();
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
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _quantityController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Coins'),
                    ),
                    TextField(
                      // keyboardType:
                      // TextInputType.numberWithOptions(decimal: true),
                      controller: _descController,

                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: _dateController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                    TextField(
                      controller: _timeController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          InputDecoration(labelText: 'Time (24 hours format)'),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 96,
                    //     width: 380,
                    //     color: Colors.grey[200],
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: Colors.red,
                    //             ),
                    //             onPressed: () {
                    //               _selectDate(context);
                    //             },
                    //             child: const Text("Choose Date"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Text(
                    //               "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),

                    //               Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 96,
                    //     width: 380,
                    //     color: Colors.grey[200],
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: Colors.red,
                    //             ),
                    //             onPressed: () {
                    //               _selectTime(context);
                    //             },
                    //             child: const Text("Choose Time"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Text("${_selectedTime.format(context)}"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () async {
                          final String name = _nameController.text;
                          final String quantity = _quantityController.text;
                          final String desc = _descController.text;
                          final String date = _dateController.text;
                          final String time = _timeController.text;
                          // if (quantity) {
                          await _products.doc(documentSnapshot!.id).update({
                            'name': name,
                            'coins': quantity,
                            'desc': desc,
                            'endDate': date,
                            'endTime': time
                          });
                          _nameController.text = '';
                          _quantityController.text = '';
                          _descController.text = '';
                          _dateController.text = '';
                          _timeController.text = '';
                          // }
                        },
                        child: Text('Update'))
                  ]),
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _quantityController.text = documentSnapshot['quantity'].toString();
    }

    // modal
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
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
                    decoration: InputDecoration(labelText: 'Add Name'),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Background color
                      ),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? quantity =
                            double.tryParse(_quantityController.text);
                        // if (quantity) {
                        await _products
                            .add({'name': name, 'quantity': quantity});
                        _nameController.text = '';
                        _quantityController.text = '';
                        // }
                      },
                      child: Text('Update'))
                ]),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted")));
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
        title: Text("Update"),
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
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle:
                        Text('Coins: ' + documentSnapshot['coins'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(children: [
                        IconButton(
                            onPressed: () => _update(documentSnapshot),
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => _delete(documentSnapshot.id),
                            icon: Icon(Icons.delete)),
                      ]),
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
