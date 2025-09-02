import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentProvider extends ChangeNotifier {
  List<assignment> assignments = [];
  bool isLoading = false;
  String? errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchAssignments() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      errorMessage = "Token not found!";
      isLoading = false;
      notifyListeners();
      return;
    }

    final response = await _apiService.get(
      AppApi.listAssignments,
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
