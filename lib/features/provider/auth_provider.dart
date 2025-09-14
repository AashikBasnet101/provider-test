import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/login/model/login.dart';
import 'package:provider_test/features/signup/model/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? email;
  String? username;
  String? fullName;
  String? contact;
  String? password;
  String? gender;
  String? role;
  ViewState loginStatus = ViewState.idle;
  ViewState signupStatus = ViewState.idle;
  String? errorMessage;
  ApiService service = ApiService();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setLoginState(ViewState value) {
    loginStatus = value;
    notifyListeners();
  }

  void setSignupState(ViewState value) {
    signupStatus = value;
    notifyListeners();
  }

  // Signup
  Future<void> signupUser() async {
    setSignupState(ViewState.loading);

    SignupU signup = SignupU(
      email: email,
      password: password,
      contact: contact,
      gender: gender,
      name: fullName,
      username: username,
      role: role,
    );

    ApiResponse response = await service.post(
      AppApi.signup,
      data: signup.toJson(),
    );

    if (response.state == ViewState.success) {
      setSignupState(ViewState.success);
    } else {
      errorMessage = response.errorMessage;
      setSignupState(ViewState.error);
    }
  }

  // Login
  Future<void> loginUser() async {
    setLoginState(ViewState.loading);

    LoginU login = LoginU(
      email: email,
      password: password,
      deviceToken: "abcd",
    );

    ApiResponse response = await service.post(
      AppApi.login,
      data: login.toJson(),
    );

    if (response.state == ViewState.success) {
      final responseData = response.data;

      // Ensure responseData is Map
      if (responseData is Map<String, dynamic>) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          final String? token = data['token'];
          final String? role = data['user']?['role'];

          final prefs = await SharedPreferences.getInstance();
          if (token != null) await prefs.setString("auth_token", token);
          if (role != null) await prefs.setString("user_role", role);

          print("Saved token: $token, role: $role");
          setLoginState(ViewState.success);
        } else {
          errorMessage = "Unexpected login response format";
          setLoginState(ViewState.error);
        }
      } else {
        errorMessage = "Unexpected login response format";
        setLoginState(ViewState.error);
      }
    } else {
      errorMessage = response.errorMessage;
      setLoginState(ViewState.error);
    }
  }

  // Validators
  String? emailValidator(String? value) =>
      value == null || value.isEmpty ? "Email cannot be empty" : null;

  String? userValidator(String? value) =>
      value == null || value.isEmpty ? "Username cannot be empty" : null;

  String? nameValidator(String? value) =>
      value == null || value.isEmpty ? "Full name cannot be empty" : null;

  String? contactValidator(String? value) =>
      value == null || value.isEmpty ? "Contact cannot be empty" : null;

  String? passwordValidator(String? value) =>
      value == null || value.isEmpty ? "Password cannot be empty" : null;

  String? genderValidator(String? value) =>
      value == null || value.isEmpty ? "Please select a gender" : null;

  void setGender(String? val) {
    gender = val;
    notifyListeners();
  }

  String? roleValidator(String? value) =>
      value == null || value.isEmpty ? "Please select a role" : null;

  void setRole(String? val) {
    role = val;
    notifyListeners();
  }
}
