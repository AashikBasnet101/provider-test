import 'package:flutter/material.dart';
import 'package:provider_test/core/utils/view_state.dart';

class NoticeProvider extends ChangeNotifier {
  // Form fields
  String? title;
  String? fileId;
  String? priority;
  String? category;
  List<String> targetAudience = [];

  // Status
  ViewState createStatus = ViewState.idle;

  // Validators
  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? priorityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a priority';
    }
    return null;
  }

  String? categoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  String? targetAudienceValidator(String? value) {
    if (targetAudience.isEmpty) {
      return 'Please select at least one audience';
    }
    return null;
  }

  // Setters
  void setPriority(String? val) {
    priority = val;
    notifyListeners();
  }

  void setCategory(String? val) {
    category = val;
    notifyListeners();
  }

  void setTargetAudience(List<String> val) {
    targetAudience = val;
    notifyListeners();
  }

  // API Call Simulation
  Future<void> createNotice() async {
    try {
      createStatus = ViewState.loading;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Here, you can implement actual API call
      // Example payload:
      final noticeData = {
        "title": title,
        "file_id": fileId,
        "priority": priority,
        "category": category,
        "target_audience": targetAudience,
        "issued_by": "Admin", // static for now
      };

      print("Notice Create Payload: $noticeData");

      // After success
      createStatus = ViewState.success;
      notifyListeners();
    } catch (e) {
      createStatus = ViewState.error;
      notifyListeners();
    }
  }
}
