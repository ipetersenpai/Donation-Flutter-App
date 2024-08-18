import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/drawer_widget.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import '../pages/profile_page.dart';
import '../pages/history_page.dart';
import '../pages/donate_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  bool _isLoading = true;
  List<Map<String, dynamic>> _donationCategories = [];

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchDonationCategories();
  }

  Future<void> _fetchDonationCategories() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      _showError('Token is missing');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/donation-categories'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _donationCategories = data.map((item) {
            return {
              'id': item['id'],
              'title': item['category_name'],
              'subtitle': item['description'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        _showError(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (error) {
      _showError('An error occurred: $error');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
      BuildContext context, String id, String title, String subtitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonatePage(
          donationId: id,
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
            fontSize: 16.0,
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _donationCategories.length,
                  itemBuilder: (context, index) {
                    final category = _donationCategories[index];
                    return GestureDetector(
                      onTap: () => _navigateToDonatePage(
                        context,
                        category['id'].toString(),
                        category['title'],
                        category['subtitle'],
                      ),
                      child: Card(
                        color: const Color(0xFF9D0606),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['title'].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['subtitle'],
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
                                    category['id'].toString(),
                                    category['title'],
                                    category['subtitle'],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF9D0606),
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
