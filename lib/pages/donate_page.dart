import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String? _selectedPaymentMethod;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<String> _createPaymentMethod() async {
    final String secretKey = dotenv.env['PAYMONGO_SECRET_KEY']!;
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');

    // Fetch user data
    final userResponse = await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (userResponse.statusCode != 200) {
      print('Error fetching user data: ${userResponse.body}');
      _showError('Error fetching user data');
      throw Exception('Error fetching user data');
    }

    final userData = jsonDecode(userResponse.body);
    final firstName = userData['first_name'];
    final middleName = userData['middle_name'];
    final lastName = userData['last_name'];
    final email = userData['email'];
    final phone = userData['contact_no'];

    final fullName =
        '${firstName ?? ''} ${middleName ?? ''} ${lastName ?? ''}'.trim();

    final response = await http.post(
      Uri.parse('https://api.paymongo.com/v1/payment_methods'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$secretKey:')),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'billing': {
              'email': email,
              'phone': phone,
              'name': fullName,
            },
            'type': _selectedPaymentMethod,
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final paymentMethod = jsonDecode(response.body);
      final paymentMethodId = paymentMethod['data']['id'];
      print('Payment Method Created: $paymentMethodId');
      return paymentMethodId;
    } else {
      print('Error creating payment method: ${response.body}');
      _showError('Error creating payment method: ${response.body}');
      throw Exception('Error creating payment method');
    }
  }

  Future<void> _createPaymentIntent(String paymentMethodId) async {
    final String secretKey = dotenv.env['PAYMONGO_SECRET_KEY']!;
    final int amountInCents =
        (double.parse(_amountController.text) * 100).toInt();

    final response = await http.post(
      Uri.parse('https://api.paymongo.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$secretKey:')),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'amount': amountInCents,
            'payment_method_allowed': [_selectedPaymentMethod],
            'currency': 'PHP',
            'capture_type': 'automatic',
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final paymentIntent = jsonDecode(response.body);
      final paymentIntentId = paymentIntent['data']['id'];
      final clientKey = paymentIntent['data']['attributes']['client_key'];

      // Attach payment method
      await _attachPaymentMethod(paymentIntentId, paymentMethodId, clientKey);

      // Store donation in the backend
      await _storeDonation(paymentIntentId, amountInCents / 100);
    }
  }

  Future<void> _attachPaymentMethod(
      String paymentIntentId, String paymentMethodId, String clientKey) async {
    final String secretKey = dotenv.env['PAYMONGO_SECRET_KEY']!;

    final response = await http.post(
      Uri.parse(
          'https://api.paymongo.com/v1/payment_intents/$paymentIntentId/attach'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$secretKey:')),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'payment_method': paymentMethodId,
            'client_key': clientKey,
            'return_url': '${dotenv.env['BASE_URL_WEB']}/payment-success',
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final nextAction = result['data']['attributes']['next_action'];
      if (nextAction != null && nextAction['type'] == 'redirect') {
        final redirectUrl = nextAction['redirect']['url'];
        if (redirectUrl != null) {
          if (!await launch(redirectUrl)) {
            throw 'Could not launch $redirectUrl';
          }
        }
      } else {
        _showError('No redirect URL found.');
      }
    }
  }

  Future<void> _storeDonation(String paymentIntentId, double amount) async {
    final String baseUrl = dotenv.env['BASE_URL']!;
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/donate'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'category_id': widget.donationId,
        'payment_option': _selectedPaymentMethod,
        'amount': amount,
        'reference_no': paymentIntentId,
      }),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showPaymentSuccessModal() {
    print('Showing Payment Success Modal');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text(
              'Thank you for your donation! Your payment was processed successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
              label: 'GCash',
              value: 'gcash',
            ),
            _buildPaymentMethodOption(
              context,
              iconPath: 'assets/maya.svg',
              label: 'PayMaya',
              value: 'paymaya',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedPaymentMethod == null ||
                            _amountController.text.isEmpty) {
                          _showError(
                              'Please select a payment method and enter an amount.');
                          return;
                        }

                        // Check if the entered amount is less than 40 pesos
                        if (double.tryParse(_amountController.text) != null &&
                            double.parse(_amountController.text) < 40) {
                          _showError(
                              'Minimum required is 40 pesos. because this include service fee of payment gateway.');
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          final paymentMethodId = await _createPaymentMethod();
                          await _createPaymentIntent(paymentMethodId);
                          _showPaymentSuccessModal();
                        } catch (e) {
                          print('Error during payment process: $e');
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
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
}
