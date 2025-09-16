import 'package:flutter/material.dart';
import 'package:provider_test/features/assignment/add_assignment.dart';
import 'package:provider_test/features/assignment/assign.dart';
import 'package:provider_test/features/assignment/assignment.dart';
import 'package:provider_test/features/home/dashboard.dart';
import 'package:provider_test/features/home/profile.dart';
import 'package:provider_test/features/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoleProvider extends ChangeNotifier {
  String _role = "user";

  String get role => _role;

  UserRoleProvider() {
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString("user_role") ?? "user";
    notifyListeners();
  }

  Future<void> updateUserRole(String newRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_role", newRole);
    _role = newRole;
    notifyListeners();
  }
}

final List<Map<String, dynamic>> buttons = [
  {
    "icon": Icons.assignment,
    "label": "Assignment",
    "backgroundColor": Colors.grey,
    "iconColor": Colors.white,
    "textColor": Colors.black,
    "page": AssignmentPage(),
  },
  {
    "icon": Icons.book,
    "label": "LogBook",

    "textColor": Colors.black,
    "page": AssignmentPage(),
  },
  {
    "icon": Icons.copy,
    "label": "Course",

    "textColor": Colors.black,
    "page": AssignmentPage(),
  },
  {
    "icon": Icons.insert_drive_file,
    "label": "Result",

    "textColor": Colors.black,
    "page": AssignmentPage(),
  },
];

final List<Map<String, dynamic>> navItems = [
  {
    "icon": Icons.home_outlined,
    "label": "Home",
    "page": const Center(child: Dashboard()),
  },
  {
    "icon": Icons.calendar_today_outlined,
    "label": "Calendar",
    "page": const Center(child: Text("I am Calendar")),
  },
  {
    "icon": Icons.notifications_outlined,
    "label": "Notification",
    "page": const Center(child: Text("I am Notifications")),
  },
  {
    "icon": Icons.person_outline,
    "label": "Profile",
    "page": const Center(child: ProfilePage()),
  },
];

final List<Widget> screens = const [AssignmentScreen(), Text("submitter here")];

//--logout--//
Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  const String tokenKey = "auth_token";
  const String userRole = "user_role";

  await prefs.remove(tokenKey);
  await prefs.remove(userRole);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text("Logged out successfully!")));

  // Navigate to Login page and remove all previous routes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const Login()),
    (Route<dynamic> route) => false,
  );
}
