import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/core/utils/helper.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/assignment.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';
import 'package:provider_test/features/widgets/custom_snackbar.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final TextEditingController _deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getSubjects();
    });
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  void getSubjects() async {
    final assignmentProvider = Provider.of<AssignmentProvider>(
      context,
      listen: false,
    );
    await assignmentProvider.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AssignmentProvider>(
        builder: (context, assignmentProvider, child) => Stack(
          children: [
            addAssignmentUi(assignmentProvider),
            (assignmentProvider.getAssignmentStatus == ViewState.loading ||
                    assignmentProvider.createAssignmentStatus ==
                        ViewState.loading)
                ? backdropFilter(context)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget addAssignmentUi(AssignmentProvider assignmentProvider) =>
      SingleChildScrollView(
        child: Column(
          children: [
            // Title Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  assignmentProvider.title = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Description Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  assignmentProvider.description = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Deadline Field - Using DatePicker
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _deadlineController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Convert to ISO8601 String
                    String isoDate = pickedDate.toUtc().toIso8601String();
                    assignmentProvider.deadline = isoDate;
                    _deadlineController.text = isoDate;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Deadline",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Faculty Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  assignmentProvider.faculty = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: "Faculty",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Semester Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  assignmentProvider.semester = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: "Semester",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Subject Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                items: assignmentProvider.subjectList
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e.name!),
                        value: e.subjectId,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  assignmentProvider.selectedSubjectId = value!;
                },
              ),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () async {
                await assignmentProvider.createAssignment();
                if (assignmentProvider.createAssignmentStatus ==
                    ViewState.success) {
                  displaySnackBar(context, assignmentSuccessMessage);
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => AssignmentScreen()),
                  );
                } else if (assignmentProvider.createAssignmentStatus ==
                    ViewState.error) {
                  displaySnackBar(context, assignmenntErrorMessage);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );
}
