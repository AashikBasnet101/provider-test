import 'package:flutter/material.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0; // keep track of active tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navItems[_currentIndex]["label"]),
      ), // dynamic title
      body: navItems[_currentIndex]["page"],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item["icon"]),
            label: item["label"],
          );
        }).toList(),
      ),
    );
  }
}
