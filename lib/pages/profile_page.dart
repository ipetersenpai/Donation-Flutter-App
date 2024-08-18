import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      _showError('Token is missing');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _firstNameController.text = data['first_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          _middleNameController.text = data['middle_name'] ?? '';
          _suffixController.text = data['suffix'] ?? '';
          _birthDateController.text =
              data['birth_date']?.split(' ')[0] ?? ''; // Only date part
          _contactNoController.text = data['contact_no'] ?? '';
          _emailController.text = data['email'] ?? '';
          _homeAddressController.text = data['home_address'] ?? '';
        });
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        _showError('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      _showError('An error occurred while fetching user data');
    }
  }

  Future<void> _updateUserProfile() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      _showError('Token is missing');
      return;
    }

    final updatedData = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'middle_name': _middleNameController.text,
      'suffix': _suffixController.text,
      'birth_date': _birthDateController.text,
      'contact_no': _contactNoController.text,
      'email': _emailController.text,
      'home_address': _homeAddressController.text,
      'gender': 'other', // This should be dynamic based on your input
    };

    try {
      final response = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        _showSuccess('User details updated successfully');
      } else {
        print(
            'Failed to update user data. Status code: ${response.statusCode}');
        _showError('Failed to update user data');
      }
    } catch (e) {
      print('Error: $e');
      _showError('An error occurred while updating user data');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            _buildTextInputField('First Name',
                controller: _firstNameController),
            const SizedBox(height: 10.0),
            _buildTextInputField('Last Name', controller: _lastNameController),
            const SizedBox(height: 10.0),
            _buildTextInputField('Middle Name',
                controller: _middleNameController),
            const SizedBox(height: 10.0),
            _buildTextInputField('Suffix', controller: _suffixController),
            const SizedBox(height: 10.0),
            _buildDateInputField(context, 'Birth Date',
                controller: _birthDateController),
            const SizedBox(height: 10.0),
            _buildTextInputField('Contact No',
                inputType: TextInputType.phone,
                controller: _contactNoController),
            const SizedBox(height: 10.0),
            _buildTextInputField('Email',
                inputType: TextInputType.emailAddress,
                controller: _emailController),
            const SizedBox(height: 10.0),
            _buildTextAreaInputField('Home Address',
                controller: _homeAddressController),
            const SizedBox(height: 20.0), // Space before the button
            _buildUpdateButton(), // Update button
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField(String label,
      {TextInputType? inputType, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          height: 50.0, // Height for the TextField
          child: TextField(
            controller: controller,
            keyboardType: inputType ?? TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaInputField(String label,
      {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        TextField(
          controller: controller,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildDateInputField(BuildContext context, String label,
      {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          height: 50.0, // Height for the TextField
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            style: const TextStyle(color: Colors.black),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                controller.text = formattedDate;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity, // Full width of the screen
      child: ElevatedButton(
        onPressed: _updateUserProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'UPDATE',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
