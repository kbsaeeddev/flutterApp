import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:testing3crud/admin/view.dart';

import 'approved.dart';
import 'pending.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text('Payments'),
            // centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Pending',
                  icon: Icon(Icons.reorder_outlined),
                ),
                Tab(
                  text: 'Approved',
                  icon: Icon(Icons.checklist_outlined),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              OrderHistoryPending(),
              OrderHistoryApproved(),
            ],
          ),
        ),
      );
}
