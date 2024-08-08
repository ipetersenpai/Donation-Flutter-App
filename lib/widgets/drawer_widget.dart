import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/history.svg',
              width: 24,
              height: 24,
              // ignore: deprecated_member_use
              color: Colors.black,
            ),
            title: const Text('Donation History'),
            onTap: () {
              // Handle Donation History tap
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/lock.svg',
              width: 24,
              height: 24,
              // ignore: deprecated_member_use
              color: Colors.black,
            ),
            title: const Text('Update Password'),
            onTap: () {
              // Handle Update Password tap
            },
          ),
          const Spacer(),
          ListTile(
            leading: SvgPicture.asset(
              'assets/logout.svg',
              width: 24,
              height: 24,
              // ignore: deprecated_member_use
              color: Colors.black,
            ),
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout tap
            },
          ),
        ],
      ),
    );
  }
}
