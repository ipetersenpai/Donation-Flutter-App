import 'package:donation_flutter_app/pages/gcash_information_page.dart';
import 'package:donation_flutter_app/pages/maya_information_page.dart';
import 'package:donation_flutter_app/pages/bpi_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DonatePage extends StatefulWidget {
  final String donationCategory;
  final String donationDescription;
  final String donationId;

  const DonatePage({
    super.key,
    required this.donationCategory,
    required this.donationDescription,
    required this.donationId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String? _selectedPaymentMethod;
  final TextEditingController _amountController = TextEditingController();

  // Map to link payment methods to corresponding pages
  final Map<String, Widget Function(String donationId, String amount)>
      paymentPages = {
    'gcash': (donationId, amount) => GcashInformationPage(
          donationId: donationId,
          amount: amount,
          paymentMethod: 'Gcash',
        ),
    'maya': (donationId, amount) => MayaInformationPage(
          donationId: donationId,
          amount: amount,
          paymentMethod: 'Maya',
        ),
    'BPI online Bank': (donationId, amount) => BPIInformationPage(
          donationId: donationId,
          amount: amount,
          paymentMethod: 'BPI online Bank',
        ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DONATE',
          style: TextStyle(fontSize: 16.0),
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
                height: 150,
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
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
              height: 50.0,
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
              label: 'BPI online Bank',
              value: 'BPI online Bank',
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                onPressed: () {
                  // Validate the amount
                  final amount = double.tryParse(_amountController.text) ?? 0;

                  if (amount < 10) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please add at least 10 amount before to proceed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_selectedPaymentMethod == null) {
                    // Show an error message for payment method
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a payment method.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Get the corresponding page for the selected payment method
                    final paymentPage = paymentPages[_selectedPaymentMethod!];
                    if (paymentPage != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => paymentPage(
                            widget.donationId,
                            _amountController.text,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'PROCEED',
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

  Widget _buildPaymentMethodOption(
    BuildContext context, {
    required String iconPath,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(color: const Color(0xFFDFDFDF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(-10.0),
          leading: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              iconPath,
              width: 34.0,
              height: 34.0,
            ),
          ),
          title: Transform.translate(
            offset: const Offset(-12.0, 0.0),
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
