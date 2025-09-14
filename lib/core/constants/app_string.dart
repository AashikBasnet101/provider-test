import 'package:flutter/material.dart';

String appName = "NIST College";
String emailLabel = "Email";
String signupLabel = "Sign Up";
String titleLabel = "Title";
String descriptionLabel = "Sign Up";
String deadlineLabel = "Sign Up";

String userLabel = "Username";
String nameLabel = "Full Name";
String contactLabel = "Contact Number";
String passwordLabel = "Password";
String genderLabel = "Gender";
String roleLabel = "Role";
String loginLabel = "Login";
String uploadLabel = "Upload Assignment";
String updateLabel = "Update Assignment";
String deleteLabel = "Delete Assignment";
String getLabel = "Assignments";
String loginSuccess = "login Successfully";
String loginfailed = "login failed";
String registerSuccess = "Signup Successfully";
String registerfailed = "Signup failed";
String assignmenntErrorMessage = "Failed to extract assignment";

String assignmentSuccessMessage = "Success to extract assignment";
String errorInvalidEmail = "Enter Your valid Email";
String errorInvalidPAssword = "Enter Your valid password";
final List<String> genderOptions = ['male', 'female', 'other'];
final List<String> roleOptions = ['student', 'teacher', 'admin'];
final List<String> facultyOptions = ['BSc. CSIT', 'BCA', 'BIM'];
final List<String> semesterOptions = [
  'First Semester',
  'Second Semester',
  'Third Semester',
  'Fourth Semester',
  'Fifth Semester',
  'Sixth Semester',
  'Seventh Semester',
  'Eighth Semester',
];

final List<Map<String, dynamic>> tabs = [
  {"icon": Icons.edit, "text": "Assigned"},
  {"icon": Icons.description, "text": "Submitted"},
];
