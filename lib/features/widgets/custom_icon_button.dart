import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double iconSize;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const CustomIconTextButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconSize = 24.0,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: iconColor),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: textColor, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
