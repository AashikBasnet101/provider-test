import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
import 'package:provider_test/features/assignment/model/updateAssignment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AssignmentProvider extends ChangeNotifier {
  // Form fields
  String? title, description, semester, faculty, deadline;
  String selectedSubjectId = "";

  // Status
  ViewState getSubjectStatus = ViewState.idle;
  ViewState createAssignmentStatus = ViewState.idle;
  ViewState getAssignmentStatus = ViewState.idle;
  // Data lists
  List<Subject> subjectList = [];
  List<Assignment> assignments = [];

  // Loading & error
  bool isLoading = false;
  String? errorMessage;

  ApiService apiService = ApiService();

  // --- SUBJECTS ---
  Future<void> getSubjects() async {
    setSubjectStatus(ViewState.loading);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    ApiResponse apiResponse = await apiService.get(
      endpoint: AppApi.getsubjects,
      token: token,
    );

    if (apiResponse.state == ViewState.success) {
      subjectList = (apiResponse.data['data'] as List<dynamic>)
          .map((e) => Subject.fromJson(e))
          .toList();
      setSubjectStatus(ViewState.success);
    } else {
      setSubjectStatus(ViewState.error);
    }
  }

  // Helper: get subject name by id
  String getSubjectName(String? id) {
    final subject = subjectList.firstWhere(
      (s) => s.subjectId == id,
      orElse: () => Subject(name: "Unknown"),
    );
    return subject.name ?? "";
  }

  void setSubjectStatus(ViewState state) {
    getSubjectStatus = state;
    notifyListeners();
  }

  void setCreateAssignmentStatus(ViewState state) {
    createAssignmentStatus = state;
    notifyListeners();
  }

  void setgetAssignmentStatus(ViewState state) {
    getAssignmentStatus = state;
    notifyListeners();
  }

  // --- ASSIGNMENTS ---
  Future<void> getAssignments() async {
    setgetAssignmentStatus(ViewState.loading);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      ApiResponse response = await apiService.get(
        endpoint: AppApi.listAssignments,
        token: token,
      );

      if (response.state == ViewState.success) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          final data = responseData['data'];
          if (data is List<dynamic>) {
            assignments = data.map((e) => Assignment.fromJson(e)).toList();
            setgetAssignmentStatus(ViewState.success);
          } else {
            errorMessage = "Unexpected assignments response format";
            setgetAssignmentStatus(ViewState.error);
          }
        } else {
          errorMessage = "Unexpected assignments response format";
          setgetAssignmentStatus(ViewState.error);
        }
      } else {
        errorMessage = response.errorMessage ?? "Failed to fetch assignments";
        setgetAssignmentStatus(ViewState.error);
      }
    } catch (e) {
      errorMessage = e.toString();
      setgetAssignmentStatus(ViewState.error);
    }
  }

  // --- CREATE ASSIGNMENT ---
  Future<void> createAssignment() async {
    setCreateAssignmentStatus(ViewState.loading);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    AssignmentCreate assignment = AssignmentCreate(
      title: title,
      description: description,
      subjectId: selectedSubjectId,
      deadline: deadline,
      semester: semester,
      faculty: faculty,
    );

    // Debug print
    print("Posting Assignment: ${assignment.toJson()}");

    ApiResponse apiResponse = await apiService.post(
      AppApi.createAssignment,
      data: assignment.toJson(),
      token: token,
    );

    if (apiResponse.state == ViewState.success) {
      setCreateAssignmentStatus(ViewState.success);
      // refresh assignment list
      await getAssignments();
    } else {
      print("Error posting assignment: ${apiResponse.errorMessage}");
      setCreateAssignmentStatus(ViewState.error);
    }
  }

  // --- DELETE ASSIGNMENT ---
  Future<void> deleteAssignment(String assignmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      errorMessage = "Auth token not found.";
      notifyListeners();
      return;
    }

    // Construct URL using the static API endpoint appended with the assignment ID
    final String url = AppApi.deleteAssignment + assignmentId;

    ApiResponse response = await apiService.delete(url, token: token);
    if (response.state == ViewState.success) {
      // Remove the assignment from your list
      assignments.removeWhere(
        (assignment) => assignment.assignmentId == assignmentId,
      );
      notifyListeners();
    } else {
      errorMessage = response.errorMessage;
      notifyListeners();
    }
  }

  //---------EDIT Asignment-----///
  Future<void> updateAssignment(
    String assignmentId, {
    String? title,
    String? description,
    String? subjectName,
    String? semester,
    String? faculty,
    DateTime? deadline,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      errorMessage = "Auth token not found.";
      notifyListeners();
      return;
    }

    final url = "${AppApi.updateAssignment}$assignmentId";

    // Build request using UpdateAssignment DTO
    final Map<String, dynamic> updateRequest = UpdateAssignment(
      title: title,
      description: description,
      subjectName: subjectName,
      semester: semester,
      faculty: faculty,
    ).toJson();

    if (deadline != null) {
      updateRequest['deadline'] = deadline.toIso8601String();
    }

    // Remove null values to send only updated fields
    updateRequest.removeWhere((k, v) => v == null);

    final response = await apiService.patch(
      url,
      token: token,
      data: updateRequest,
    );

    if (response.state == ViewState.success) {
      final index = assignments.indexWhere(
        (a) => a.assignmentId == assignmentId,
      );
      if (index != -1) {
        final old = assignments[index];

        // Manually rebuild the Assignment object
        assignments[index] = Assignment(
          assignmentId: old.assignmentId,
          title: title ?? old.title,
          description: description ?? old.description,
          faculty: faculty ?? old.faculty,
          semester: semester ?? old.semester,
          teacher: old.teacher,
          deadline: deadline?.toIso8601String() ?? old.deadline,
          subject: subjectName != null
              ? Subject(name: subjectName)
              : old.subject,
        );
      }
      notifyListeners();
    } else {
      errorMessage = response.errorMessage;
      notifyListeners();
    }
  }
}
