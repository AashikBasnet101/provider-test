import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
import 'package:provider_test/features/assignment/model/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentProvider extends ChangeNotifier {
  List<assignment> assignments = [];
  List<Subjects> subjectlist = [];
  String selectedSubjectId = "";
  ViewState getAssignmentStatus = ViewState.idle;
  bool isLoading = false;
  String? errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> getAssignments() async {
    isLoading = true;
    notifyListeners();

    setAssignmentStatus(ViewState state) {
      getAssignmentStatus = state;
      notifyListeners();
    }

    Future<void> getAssignment() async {
      setAssignmentStatus(ViewState.loading);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");
      ApiResponse apiResponse = await ApiService().get(
        endpoint: AppApi.getsubjects,
        token: token,
      );
      if (apiResponse.state == ViewState.success) {
        subjectlist.addAll(
          (apiResponse.data['data'] as List<dynamic>)
              .map((e) => Subjects.fromJson(e))
              .toList(),
        );
        print(subjectlist);

        setAssignmentStatus(ViewState.success);
      } else if (apiResponse.state == ViewState.error) {
        setAssignmentStatus(ViewState.error);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      errorMessage = "Token not found!";
      isLoading = false;
      notifyListeners();
      return;
    }

    final response = await _apiService.get(
      endpoint: AppApi.listAssignments,
      token: token,
    );

    if (response.state == ViewState.success) {
      print("Assignments response: ${response.data}");
      final List data = response.data['data']; // extract list
      assignments = data.map((json) => assignment.fromJson(json)).toList();
    } else {
      errorMessage = response.errorMessage ?? "Failed to fetch assignments";
    }

    isLoading = false;
    notifyListeners();
  }
}

final List<Map<String, dynamic>> tabs = [
  {"icon": Icons.edit, "text": "Assigned"},
  {"icon": Icons.description, "text": "Submitted"},
];
