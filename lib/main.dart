import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/assign.dart';
import 'package:provider_test/features/home/bottom_navbar.dart';
import 'package:provider_test/features/home/dashboard.dart';
import 'package:provider_test/features/login/login.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';
import 'package:provider_test/features/provider/auth_provider.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';
import 'package:provider_test/features/provider/notice_provider.dart';
import 'package:provider_test/features/provider/test_provider.dart';
import 'package:provider_test/features/signup/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("auth_token");
    setState(() {
      token;
    });
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NoticeProvider()),
        ChangeNotifierProvider(create: (context) => UserRoleProvider()),
        ChangeNotifierProvider(create: (context) => TestProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: token != null ? BottomNavbar() : Signup(),
      ),
    );
  }
}
