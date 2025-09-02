import 'dart:ui';

import 'package:flutter/material.dart';

displaySnackBar(BuildContext context, String message) {
  var snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
