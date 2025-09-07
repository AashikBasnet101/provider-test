import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  @override
  void initState() {
    Future.microtask(() {
      getSubjects();
    });
    super.initState();
  }

  void getSubjects() async {
    final assignmentProvider = Provider.of<AssignmentProvider>(
      context,
      listen: false,
    );
    await assignmentProvider.getAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AssignmentProvider>(
        builder: (context, assignmentProvider, child) => Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: assignmentProvider.subjectlist
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e.code!),
                      value: e.subjectId,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                assignmentProvider.selectedSubjectId = value!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
