import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/utils/helper.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/update_assignment.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';

import 'package:provider_test/features/provider/dashboard_provider.dart';

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
        builder: (context, provider, child) => Stack(
          children: [
            assignmentUi(provider),
            provider.getAssignmentStatus == ViewState.loading
                ? backdropFilter(context)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget assignmentUi(AssignmentProvider provider) => ListView.builder(
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          onPressed: () async {
                            if (item.assignmentId != null) {
                              // Show confirmation dialog
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete Assignment"),
                                  content: Text(
                                    "Do you really want to delete this assignment?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              // If user confirmed, delete the assignment
                              if (confirm == true) {
                                await Provider.of<AssignmentProvider>(
                                  context,
                                  listen: false,
                                ).deleteAssignment(item.assignmentId!);

                                // Optional: show a snackbar after deletion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Assignment deleted successfully.",
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),

                        const SizedBox(height: 5),
                        IconButton(
                          onPressed: () async {
                            final assignmentProvider =
                                Provider.of<AssignmentProvider>(
                                  context,
                                  listen: false,
                                );

                            // Navigate to UpdateAssignmentPage
                            bool? updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAssignmentPage(
                                  assignment: item, // <-- use `item` here
                                ),
                              ),
                            );

                            // Refresh assignments list if update was successful
                            if (updated == true) {
                              await assignmentProvider.getAssignments();
                            }
                          },
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
}
