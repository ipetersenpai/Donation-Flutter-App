import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // Clip the rounded corners
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('Juan dela Cruz'),
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
                borderRadius: BorderRadius.zero, // Remove the border radius
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/history.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
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
                Navigator.pushNamed(context, '/profile');
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
              onTap: () {
                // Handle Logout tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
