import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final storage = const FlutterSecureStorage();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  Future<void> _updatePassword() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      _showError('Token is missing');
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('All fields are required.');
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        _isPasswordValid = false;
      });
      _showError('New password must be at least 8 characters long.');
      return;
    } else {
      setState(() {
        _isPasswordValid = true;
      });
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _isConfirmPasswordValid = false;
      });
      _showError('New passwords do not match.');
      return;
    } else {
      setState(() {
        _isConfirmPasswordValid = true;
      });
    }

    try {
      final response = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}/user/password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: '''
        {
          "current_password": "$currentPassword",
          "new_password": "$newPassword"
        }
        ''',
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        _showError('Failed to update password. Please try again.');
      }
    } catch (e) {
      print('Exception: $e');
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Password updated successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacementNamed('/dashboard');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UPDATE PASSWORD',
          style: TextStyle(fontSize: 16.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPasswordInputField('Current Password',
                        controller: _currentPasswordController),
                    const SizedBox(height: 10.0),
                    _buildPasswordInputField('New Password',
                        controller: _newPasswordController),
                    if (!_isPasswordValid)
                      const Text(
                        'Password must be at least 8 characters long.',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 10.0),
                    _buildPasswordInputField('Confirm New Password',
                        controller: _confirmPasswordController),
                    if (!_isConfirmPasswordValid)
                      const Text(
                        'New passwords do not match.',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20.0),
                    _buildPasswordStrengthInfo(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInputField(String label,
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
          height: 50.0,
          child: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Strong Password Guidelines:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          '• Use at least 8 characters\n'
          '• Include both uppercase and lowercase letters\n'
          '• Include at least one number\n'
          '• Include at least one special character (e.g., @, #, \$, %)',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        onPressed: _updatePassword,
        child: const Text(
          'UPDATE PASSWORD',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
