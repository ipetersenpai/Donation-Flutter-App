import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 20.0, // Smaller icon size
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.history,
            size: 20.0, // Smaller icon size
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 20.0, // Smaller icon size
          ),
          label: 'Profile',
        ),
      ],
      iconSize: 20.0, // Set overall icon size
      selectedFontSize: 12.0, // Reduce selected label font size
      unselectedFontSize: 12.0, // Reduce unselected label font size
      elevation: 5.0, // Optional: to add a little shadow effect
      backgroundColor: Colors.white, // Optional: background color
      selectedItemColor:
          const Color(0xFF6750A4), // Optional: selected icon color
      unselectedItemColor: Colors.grey, // Optional: unselected icon color
    );
  }
}
