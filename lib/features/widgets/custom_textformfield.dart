import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextform extends StatelessWidget {
  CustomTextform({
    super.key,
    this.labelText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.decoration,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
  });
  Widget? suffixIcon, prefixIcon;
  String? Function(String?)? validator;
  String? labelText;
  void Function(String)? onChanged;
  InputDecoration? decoration = const InputDecoration();
  TextInputType? keyboardType;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
