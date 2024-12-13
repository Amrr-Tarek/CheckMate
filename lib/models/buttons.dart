import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const Button({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(56, 56, 56, 0.5),
            blurRadius: 20,
            offset: Offset(0, 5),
            spreadRadius: -5)
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: const Size(double.infinity, 48), // Full width button
        ),
        onPressed: onPress,
        child: Text(
          text, //
          style: TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
