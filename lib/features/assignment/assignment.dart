import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_color.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';
import 'package:provider_test/features/widgets/custom_elevatedbutton.dart';
import 'package:provider_test/features/widgets/custom_icon_button.dart';
import '../provider/assignment_provider.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AssignmentProvider>(
        context,
        listen: false,
      ).getAssignments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.assignments.isEmpty) {
            return Center(
              child: Text(provider.errorMessage ?? "No assignments"),
            );
          }

          return ListView.builder(
            itemCount: provider.assignments.length,
            itemBuilder: (context, index) {
              final item = provider.assignments[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assignment details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Faculty: ${item.faculty ?? ""}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Semester: ${item.semester ?? ""}"),
                            Text("Subject: ${item.subject?.name ?? ""}"),
                            Text("Description: ${item.description ?? ""}"),
                            Text("Deadline: ${item.deadline ?? ""}"),
                          ],
                        ),
                      ),

                      // Action buttons for admin/teacher
                      Consumer<UserRoleProvider>(
                        builder: (context, roleProvider, _) {
                          if (roleProvider.role == "admin" ||
                              roleProvider.role == "teacher") {
                            return Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                                const SizedBox(height: 5),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit, color: Colors.green),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
