import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_color.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment"),
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [
          // Toggle Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              tabs.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Icon(
                        tabs[index]["icon"],
                        color: selectedIndex == index
                            ? primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tabs[index]["text"],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? primaryColor
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (selectedIndex == index)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 40,
                          color: primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Screen content
          Expanded(child: screens[selectedIndex]),
        ],
      ),

      // ✅ Floating Action Button
      floatingActionButton: Consumer<UserRoleProvider>(
        builder: (context, roleProvider, _) {
          if (roleProvider.role == "admin" || roleProvider.role == "teacher") {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Text("hehe")),
                );
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            );
          }
          return const SizedBox(); // no FAB for student role
        },
      ),
    );
  }
}

/// Dummy Screens — replace with your real ones
class AssignedScreen extends StatelessWidget {
  const AssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Assigned Assignments"));
  }
}

class SubmittedScreen extends StatelessWidget {
  const SubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Submitted Assignments"));
  }
}
