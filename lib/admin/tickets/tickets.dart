import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:testing3crud/admin/tickets/runner.dart';
import 'package:testing3crud/admin/tickets/winner.dart';
import 'package:testing3crud/admin/view.dart';



class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text('Tickets'),
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
              Runner(),
              Winner(),
            ],
          ),
        ),
      );
}
