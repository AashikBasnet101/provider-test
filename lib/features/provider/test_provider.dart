import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestProvider extends ChangeNotifier {
  int a = 0;
  int loveCounter = 0;
  bool passwordVisibillity = false;
  bool isFavorite = false;
  increaseValue() {
    a++;
    notifyListeners();
  }

  decreaseValue() {
    a--;
    notifyListeners();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    loveCounter++;
    notifyListeners();
  }

  String? token, role;

  readValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    print("token value is $token");
    this.token = token;
    notifyListeners();
  }

  readValue1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString("user_role");
    print("role value is $role");
    this.role = role;
    notifyListeners();
  }
}
