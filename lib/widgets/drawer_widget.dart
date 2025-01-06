import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final storage = const FlutterSecureStorage();
  String _fullName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = response.body; // You should parse the response body
        final Map<String, dynamic> data = jsonDecode(userData);

        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';

        setState(() {
          _fullName = '$firstName $lastName';
        });
      } else {
        setState(() {
          _fullName = 'Failed to load name';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _fullName = 'Error loading name';
      });
    }
  }

  Future<void> _logout() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'access_token');
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        // Handle error
        print('Logout failed');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_fullName),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  'assets/user-logo.svg',
                  width: 50,
                  height: 50,
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF9D0606),
                borderRadius: BorderRadius.zero,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/lock.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: const Text('Update Password'),
              onTap: () {
                Navigator.pushNamed(context, '/update-password');
              },
            ),
            const Spacer(),
            ListTile(
              leading: SvgPicture.asset(
                'assets/logout.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
