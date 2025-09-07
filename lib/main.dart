import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/assign.dart';
import 'package:provider_test/features/home/bottom_navbar.dart';
import 'package:provider_test/features/home/dashboard.dart';
import 'package:provider_test/features/login/login.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';
import 'package:provider_test/features/provider/auth_provider.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';
import 'package:provider_test/features/provider/test_provider.dart';
import 'package:provider_test/features/signup/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
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
        home: Signup(),
      ),
    );
  }
}
