import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Make sure this import is included
import 'package:flutter_svg/flutter_svg.dart'; // Import this for SVG images

class DonatePage extends StatefulWidget {
  final String donationCategory;
  final String donationDescription;

  const DonatePage({
    super.key,
    required this.donationCategory,
    required this.donationDescription,
  });

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DONATE',
          style: TextStyle(
            fontSize:
                16.0, // Adjust this value to make the text smaller or larger
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF9D0606),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                height: 150, // Adjust this value as needed
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.donationCategory.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.donationDescription,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
                height:
                    10.0), // Adjusted space between the card and the next section
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Margin around the 'Amount' text
              child: const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 50.0, // Add margin to the left and right
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only allow numbers
                decoration: const InputDecoration(
                  hintText: '0.00', // Use hintText as a placeholder
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                  border:
                      OutlineInputBorder(), // Add a border to the input field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
                height:
                    10.0), // Adjusted space between the card and the next section
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Margin around the 'Amount' text
              child: const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            _buildPaymentMethodOption(
              context,
              iconPath: 'assets/gcash.svg',
              label: 'Gcash',
              value: 'gcash',
            ),
            _buildPaymentMethodOption(
              context,
              iconPath: 'assets/maya.svg',
              label: 'Maya',
              value: 'maya',
            ),
            _buildPaymentMethodOption(
              context,
              iconPath: 'assets/bpi.svg',
              label: 'Card',
              value: 'card',
            ),
            const Spacer(),
            Container(
              width: double.infinity, // Full width of the screen
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(100.0), // Fully rounded corners
                  ),
                ),
                onPressed: () {
                  // Handle donation logic here
                },
                child: const Text(
                  'DONATE',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(BuildContext context,
      {required String iconPath,
      required String label,
      required String value}) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 8.0), // Margin around each item
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(100.0), // Rounded corners for the whole item
        border: Border.all(color: const Color(0xFFDFDFDF)), // Border color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15.0), // Add horizontal padding
        child: ListTile(
          contentPadding:
              const EdgeInsets.all(-10.0), // Keep contentPadding as zero
          leading: Container(
            width: 70.0, // Width of the icon container
            height: 70.0, // Height of the icon container
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(100.0), // Rounded corners for the logo
            ),
            padding: const EdgeInsets.all(4.0), // Padding inside the container
            child: SvgPicture.asset(
              iconPath,
              width: 34.0, // Icon width inside the container
              height: 34.0, // Icon height inside the container
            ),
          ),
          title: Transform.translate(
            offset: const Offset(
                -12.0, 0.0), // Adjust the value to shift the label to the left
            child: Text(label, style: const TextStyle(fontSize: 16.0)),
          ),
          trailing: Radio<String>(
            value: value,
            groupValue: _selectedPaymentMethod,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPaymentMethod = newValue;
              });
            },
          ),
          onTap: () {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
        ),
      ),
    );
  }
}
