import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
class Button extends StatelessWidget {

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double height;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.boxColor,
    this.textColor = AppColors.textColor,
    this.borderRadius = 24.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.verticalPadding = 8.0,
    this.horizontalPadding = 0.0,
    this.height = 48.0,
  });
  @override
Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(double.infinity, height),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
