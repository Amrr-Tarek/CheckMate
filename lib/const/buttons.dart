import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const Button({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors().boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        minimumSize: const Size(double.infinity, 48), // Full width button
      ),
      onPressed: onPress,
      child: Text(
        text, //
        style: TextStyle(
          color: AppColors().backgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
