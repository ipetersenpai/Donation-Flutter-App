import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/history_page.dart';
import 'pages/profile_page.dart';
import 'pages/about_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/register': (context) => RegisterPage(),
        '/history': (context) => const HistoryPage(),
        '/profile': (context) => const ProfilePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
