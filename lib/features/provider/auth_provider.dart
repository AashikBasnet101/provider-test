import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider_test/core/constants/app_api.dart';
import 'package:provider_test/core/services/api_services.dart';
import 'package:provider_test/core/utils/api_response.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/login/login.dart';
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
  String? role; // store selected gender
  ViewState loginStatus = ViewState.idle;
  ViewState signupStatus = ViewState.idle;
  String? errorMessage;
  ApiService service = ApiService();

  setLoginState(ViewState value) {
    loginStatus = value;
    notifyListeners();
  }

  setSignupState(ViewState value) {
    signupStatus = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // Signup method
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
    } else if (response.state == ViewState.error) {
      errorMessage = response.errorMessage;
      setSignupState(ViewState.error);
    }
  }

  //login
  Future<void> LoginUser() async {
    setLoginState(ViewState.loading);

    LoginU login = LoginU(email: email, password: password, deviceToken: "abc");

    ApiResponse response = await service.post(
      AppApi.login,
      data: login.toJson(),
    );

    if (response.state == ViewState.success) {
      setLoginState(ViewState.success);
      final data = response.data['data'];
      final String? token = data?['token'];
      final String? role = data?['user']?['role'];

      final prefs = await SharedPreferences.getInstance();

      if (token != null) await prefs.setString("auth_token", token);
      if (role != null) await prefs.setString("user_role", role);

      print("Saved token: $token, role: $role");
    } else if (response.state == ViewState.error) {
      errorMessage = response.errorMessage;
      setLoginState(ViewState.error);
    }
  }

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Validators
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Email cannot be empty";
    return null;
  }

  String? userValidator(String? value) {
    if (value == null || value.isEmpty) return "Username cannot be empty";
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return "Full name cannot be empty";
    return null;
  }

  String? contactValidator(String? value) {
    if (value == null || value.isEmpty) return "Contact cannot be empty";
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Password cannot be empty";

    return null;
  }

  String? genderValidator(String? value) {
    if (value == null || value.isEmpty) return "Please select a gender";
    return null;
  }

  // Update gender
  void setGender(String? val) {
    gender = val;
    notifyListeners();
  }

  String? roleValidator(String? value) {
    if (value == null || value.isEmpty) return "Please select a role";
    return null;
  }

  // Update gender
  void setrole(String? val) {
    role = val;
    notifyListeners();
  }
}
