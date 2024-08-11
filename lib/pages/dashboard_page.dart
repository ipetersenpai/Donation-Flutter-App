import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer_widget.dart'; // Import the drawer widget
import '../widgets/bottom_navigation_bar_widget.dart'; // Import the BottomNavigationBar widget
import '../pages/profile_page.dart'; // Import the ProfilePage
import '../pages/history_page.dart'; // Import the HistoryPage
import '../pages/donate_page.dart'; // Import the DonatePage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> donationCategories = [
    {"title": "WISDOM", "subtitle": "Alay Kapwa para sa Karunungan"},
    {"title": "HEALTH", "subtitle": "Alay Kapwa para sa Kalusugan"},
    {"title": "CALAMITY", "subtitle": "Alay Kapwa para sa Kalamidad"},
    {"title": "SKILLS", "subtitle": "Alay Kapwa para sa Kasanayan"},
  ];

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

  void _navigateToDonatePage(
      BuildContext context, String title, String subtitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonatePage(
          donationCategory: title,
          donationDescription: subtitle,
        ),
      ),
    );
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
                  ? 'HISTORY'
                  : 'PROFILE',
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
        children: [
          ListView.builder(
            itemCount: donationCategories.length,
            itemBuilder: (context, index) {
              final category = donationCategories[index];
              return GestureDetector(
                onTap: () => _navigateToDonatePage(
                  context,
                  category["title"]!,
                  category["subtitle"]!,
                ),
                child: Card(
                  color: const Color(0xFF9D0606),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category["subtitle"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () => _navigateToDonatePage(
                              context,
                              category["title"]!,
                              category["subtitle"]!,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .white, // Correct property for background color
                              foregroundColor: const Color(
                                  0xFF9D0606), // Correct property for text/icon color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("DONATE NOW"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const HistoryPage(), // History content
          const ProfilePage(), // Profile content
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
