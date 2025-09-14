import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentProvider extends ChangeNotifier {
  // Form fields
  String? title, description, semester, faculty, deadline;
  String selectedSubjectId = "";

  // Status
  ViewState getSubjectStatus = ViewState.idle;
  ViewState createAssignmentStatus = ViewState.idle;

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

  // --- ASSIGNMENTS ---
  Future<void> getAssignments() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      ApiResponse apiResponse = await apiService.get(
        endpoint: AppApi.listAssignments,
        token: token,
      );

      if (apiResponse.state == ViewState.success) {
        assignments = (apiResponse.data['data'] as List<dynamic>)
            .map((e) => Assignment.fromJson(e))
            .toList();
      } else {
        errorMessage =
            apiResponse.errorMessage ?? "Failed to fetch assignments";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
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
}
