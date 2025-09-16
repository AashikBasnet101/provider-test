import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/core/utils/helper.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/provider/assignment_provider.dart';
import 'package:provider_test/features/widgets/custom_snackbar.dart';

class UpdateAssignmentPage extends StatefulWidget {
  final assignment;

  const UpdateAssignmentPage({super.key, required this.assignment});

  @override
  State<UpdateAssignmentPage> createState() => _UpdateAssignmentPageState();
}

class _UpdateAssignmentPageState extends State<UpdateAssignmentPage> {
  final TextEditingController _deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final assignment = widget.assignment;
    final provider = Provider.of<AssignmentProvider>(context, listen: false);

    // Initialize provider fields
    provider.title = assignment.title ?? "";
    provider.description = assignment.description ?? "";
    provider.faculty = assignment.faculty ?? "";
    provider.semester = assignment.semester ?? "";
    provider.deadline = assignment.deadline ?? "";
    provider.selectedSubjectId = assignment.subject?.subjectId;

    _deadlineController.text = provider.deadline ?? "";

    Future.microtask(() => provider.getSubjects());
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Assignment")),
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: provider.title,
                      onChanged: (value) => provider.title = value.trim(),
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: provider.description,
                      onChanged: (value) => provider.description = value.trim(),
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
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
                          String isoDate = pickedDate.toUtc().toIso8601String();
                          provider.deadline = isoDate;
                          _deadlineController.text = isoDate;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Deadline",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: provider.faculty,
                      onChanged: (value) => provider.faculty = value.trim(),
                      decoration: const InputDecoration(
                        labelText: "Faculty",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: provider.semester,
                      onChanged: (value) => provider.semester = value.trim(),
                      decoration: const InputDecoration(
                        labelText: "Semester",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                      value: provider.selectedSubjectId,
                      items: provider.subjectList
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.subjectId,
                              child: Text(s.name ?? ""),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => provider.selectedSubjectId = value!,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await provider.updateAssignment(
                        widget.assignment.assignmentId!,
                        title: provider.title,
                        description: provider.description,
                        faculty: provider.faculty,
                        semester: provider.semester,
                        subjectName: provider.getSubjectName(
                          provider.selectedSubjectId,
                        ),
                        deadline:
                            provider.deadline != null &&
                                provider.deadline!.isNotEmpty
                            ? DateTime.parse(provider.deadline!)
                            : null,
                      );

                      if (provider.getAssignmentStatus == ViewState.success) {
                        displaySnackBar(context, "Updated successfully!");
                        Navigator.pop(context, true);
                      } else {
                        displaySnackBar(context, "Update failed!");
                      }
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            ),
            if (provider.getAssignmentStatus == ViewState.loading)
              backdropFilter(context),
          ],
        ),
      ),
    );
  }
}
