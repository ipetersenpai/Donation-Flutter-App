import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer_widget.dart'; // Import the drawer widget

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/burger-menu.svg',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('History Page Content'),
      ),
      drawer: const AppDrawer(), // Use the reusable drawer widget
    );
  }
}
