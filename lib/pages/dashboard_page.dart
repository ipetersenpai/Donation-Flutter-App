import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer_widget.dart'; // Import the drawer widget
import '../widgets/bottom_navigation_bar_widget.dart'; // Import the BottomNavigationBar widget
import '../pages/profile_page.dart'; // Import the ProfilePage
import '../pages/history_page.dart'; // Import the HistoryPage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'DONATION CATEGORY'
              : _currentIndex == 1
                  ? 'History'
                  : 'Profile',
          style: const TextStyle(
            fontSize:
                16.0, // Adjust this value to make the text smaller or larger
          ),
        ),
        centerTitle: true,
        leading: _currentIndex == 0
            ? IconButton(
                icon: SvgPicture.asset(
                  'assets/burger-menu.svg',
                  width: 24,
                  height: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate to the first page (Dashboard)
                  _pageController.jumpToPage(0);
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
        actions: _currentIndex != 0
            ? [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/burger-menu.svg',
                    width: 24,
                    height: 24,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ]
            : [],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          Center(child: Text('Dashboard Page')), // Home content
          HistoryPage(), // History content
          ProfilePage(), // Profile content
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      drawer: const AppDrawer(), // Use the reusable drawer widget
    );
  }
}
