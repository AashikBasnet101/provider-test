import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/add_assignment.dart';
import 'package:provider_test/features/notice/add_notice.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.map((btn) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btn["page"]),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(btn["icon"], size: 32, color: Colors.grey[700]),
                    const SizedBox(height: 6),
                    Text(btn["label"], style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Consumer<UserRoleProvider>(
        builder: (context, roleProvider, _) {
          if (roleProvider.role == "admin") {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNoticeScreen(),
                  ),
                );
              },
              backgroundColor: Colors.blue, // Replace with your primaryColor
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            );
          } else {
            return const SizedBox.shrink(); // Hides FAB for other roles
          }
        },
      ),
    );
  }
}
