import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BPIInformationPage extends StatefulWidget {
  final String? paymentMethod;
  final String donationId;
  final String amount;

  const BPIInformationPage({
    super.key,
    required this.donationId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BPIInformationPageState createState() => _BPIInformationPageState();
}

class _BPIInformationPageState extends State<BPIInformationPage> {
  final TextEditingController _proofController = TextEditingController();
  final TextEditingController _referenceNoController = TextEditingController();
  final storage = const FlutterSecureStorage();
  PlatformFile? _selectedFile;
  final GlobalKey _globalKey = GlobalKey(); // Define the GlobalKey

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _proofController.text = _selectedFile!.name;
          Fluttertoast.showToast(msg: '${_selectedFile!.name} selected');
        });
      } else {
        Fluttertoast.showToast(msg: 'No file selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error selecting file: $e');
    }
  }

  Future<void> _saveImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final result = await ImageGallerySaver.saveImage(
          byteData!.buffer.asUint8List(),
          quality: 100,
          name: "payment_qr");

      if (result != null && result['isSuccess']) {
        Fluttertoast.showToast(msg: 'QR code saved to gallery');
      } else {
        Fluttertoast.showToast(msg: 'Failed to save QR code');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving image: $e');
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(msg: 'Copied to clipboard');
  }

  Future<void> _makeDonation() async {
    final token = await storage.read(key: 'access_token');

    if (token == null) {
      Fluttertoast.showToast(msg: 'Access token is not available');
      return;
    }

    if (widget.paymentMethod == null) {
      Fluttertoast.showToast(msg: 'Payment method is not provided');
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['BASE_URL']}/donate'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['category_id'] = widget.donationId;
    request.fields['payment_option'] = widget.paymentMethod!;
    request.fields['amount'] = widget.amount;
    request.fields['reference_no'] = _referenceNoController.text;

    // Handle file upload
    if (_selectedFile != null) {
      try {
        final file = File(_selectedFile!.path!);
        Uint8List fileBytes = await file.readAsBytes();

        if (fileBytes.isNotEmpty) {
          final stream = http.ByteStream.fromBytes(fileBytes);

          request.files.add(
            http.MultipartFile(
              'attachment_file',
              stream,
              fileBytes.length,
              filename: _selectedFile!.name,
              contentType: MediaType(
                _getMimeType(_selectedFile!.extension ?? ''),
                'octet-stream',
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'File bytes are empty');
          return;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error processing file: $e');
        return;
      }
    } else {
      Fluttertoast.showToast(msg: 'No file selected');
      return;
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Donation Successful'),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushReplacementNamed('/dashboard');
                  },
                ),
              ],
            );
          },
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        Fluttertoast.showToast(
            msg:
                'Donation failed: ${response.statusCode}, Response: $responseBody');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BPI BANK INFORMATION',
          style: TextStyle(fontSize: 16.0),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please scan the QR code or use the phone number to make the payment.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            RepaintBoundary(
              key: _globalKey, // Assign the GlobalKey to RepaintBoundary
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9D0606), // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Optional padding to ensure the SVG is not too close to the border
                  child: SvgPicture.asset(
                    'assets/payment_qr/paymentqr.svg',
                    height: 200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save QR Code'),
              onPressed: _saveImage,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Account Name: Juan Dela Cruz Jr',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  onPressed: () => _copyToClipboard('Juan Dela Cruz Jr'),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Account No: 1234-5678-9012-3456',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  onPressed: () => _copyToClipboard('1234-5678-9012-3456'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Proof of Payment',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              _selectedFile != null
                  ? 'Selected: ${_selectedFile!.name}'
                  : 'No File attached yet',
              style: TextStyle(
                  fontSize: 16.0,
                  color: _selectedFile != null ? Colors.black : Colors.grey),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach File'),
              onPressed: _selectFile,
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 16.0),
            const Text(
              'Reference Number (Optional)',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _referenceNoController,
              decoration: const InputDecoration(
                hintText: 'Enter reference number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _makeDonation,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          child: const Text(
            'SUBMIT',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
