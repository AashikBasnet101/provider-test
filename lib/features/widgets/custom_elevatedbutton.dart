import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.child,
    this.foregroundColor,
    this.onPressed,
  });

  final double? borderRadius;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Increased height for better usability
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          backgroundColor: backgroundColor ?? Colors.green,
          foregroundColor: foregroundColor ?? Colors.white,
        ),
        onPressed: onPressed,
        child: Center(child: child), // Center the child widget
      ),
    );
  }
}
