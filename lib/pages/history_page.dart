import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  List<dynamic> _donations = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDonationHistory();
  }

  Future<void> _fetchDonationHistory() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Token is missing';
      });
      return;
    }

    final url = Uri.parse('${dotenv.env['BASE_URL']}/user/donations');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _donations = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text(_errorMessage))
              : _donations.isEmpty
                  ? const Center(child: Text('No Donation was Made'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _donations.length,
                      itemBuilder: (context, index) {
                        final donation = _donations[index];
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              donation['category_name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9D0606),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Option: ${donation['payment_option'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Amount: ₱${donation['amount'] ?? '0.00'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Reference no: ${donation['reference_no'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Date Donated: ${donation['created_at'] != null ? DateTime.parse(donation['created_at']).toLocal().toString() : 'Unknown'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
