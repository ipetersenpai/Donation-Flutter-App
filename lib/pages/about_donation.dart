import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:url_launcher/url_launcher.dart';

class AboutDonationPage extends StatelessWidget {
  final String? about;
  final String? link;

  const AboutDonationPage({
    super.key,
    this.about,
    this.link,
  });

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    print("Attempting to launch: $uri");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch: $uri");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Could not launch the link. The link is displayed below."),
        ),
      );
    }
  }

  // Method to copy the link to the clipboard
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABOUT DONATION',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About this Donation Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                about ?? 'Did not provide',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              if (link != null && link!.isNotEmpty) ...[
                const Text(
                  'For more information, link below:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Link that spans full width and can be tapped
                InkWell(
                  onTap: () => _launchURL(context, link!),
                  child: Container(
                    width:
                        double.infinity, // Make the link container full width
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      link!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _copyToClipboard(context, link!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Copy link"),
                ),
              ] else ...[
                const Text(
                  'Link not provided',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
