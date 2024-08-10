import 'package:flutter/material.dart';

class DonatePage extends StatelessWidget {
  final String donationCategory;

  const DonatePage({super.key, required this.donationCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to $donationCategory'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Donation page for $donationCategory'),
      ),
    );
  }
}
