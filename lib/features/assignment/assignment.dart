import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ).fetchAssignments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),
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
                child: ListTile(
                  title: Text("${item.faculty ?? ""}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Semester: ${item.semester ?? ""}"),
                      Text("Subject: ${item.subject?.name ?? ""}"),
                      Text("Description: ${item.description ?? ""}"),

                      Text("Deadline: ${item.deadline ?? ""}"),
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
