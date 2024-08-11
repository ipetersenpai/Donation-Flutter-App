import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            _buildTextInputField('First Name'),
            const SizedBox(height: 10.0),
            _buildTextInputField('Last Name'),
            const SizedBox(height: 10.0),
            _buildTextInputField('Middle Name'),
            const SizedBox(height: 10.0),
            _buildTextInputField('Suffix'),
            const SizedBox(height: 10.0),
            _buildDateInputField(
                context, 'Birth Date'), // Birth Date with Date Picker
            const SizedBox(height: 10.0),
            _buildTextInputField('Contact No', inputType: TextInputType.phone),
            const SizedBox(height: 10.0),
            _buildTextInputField('Email',
                inputType: TextInputType.emailAddress),
            const SizedBox(height: 10.0),
            _buildTextAreaInputField('Home Address'),
            const SizedBox(height: 20.0), // Space before the button
            _buildUpdateButton(), // Update button
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField(String label, {TextInputType? inputType}) {
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

  Widget _buildTextAreaInputField(String label) {
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
        const TextField(
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildDateInputField(BuildContext context, String label) {
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
                // Format and set the selected date in the TextField
                String formattedDate =
                    "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                // Use a TextEditingController to set the value
                TextEditingController().text = formattedDate;
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
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.blue, // Button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0), // Fully rounded corners
          ),
        ),
        onPressed: () {
          // Handle update logic here
        },
        child: const Text(
          'UPDATE',
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
