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
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
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

/// A custom check box widget that displays a circular check box with an optional checkmark icon,
/// along with an optional text label.
///
/// This widget animates between checked and unchecked states, with customizable behavior through
/// the [isChecked] property and the [onChanged] callback.
///
/// Example usage:
/// ```dart
/// CheckBoxWidget(
///   isChecked: isChecked,
///   text: "My Check Box", // Text to display next to the check box
///   onChanged: (newState) {
///     setState(() {
///       isChecked = newState;
///     });
///   },
/// );
/// ```
class CheckBoxWidget extends StatefulWidget {
  /// A boolean value representing whether the check box is checked or not.
  final bool isChecked;

  /// A callback function that is called when the check box state changes.
  ///
  /// The [onChanged] callback should update the parent widget's state with the new value.
  final ValueChanged<bool> onChanged;

  /// The text label to display next to the check box.
  final Text text;

  const CheckBoxWidget(
      {Key? key,
      required this.isChecked,
      required this.onChanged,
      this.text = const Text(
          "") // Default value is an empty string if no text is provided
      })
      : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isChecked); // Toggle the state when tapped
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // Align the check box and text together
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: widget.isChecked ? AppColors.boxColor : Colors.grey[300],
              shape: BoxShape.circle, // Make it circular
              border: Border.all(
                color: AppColors.boxColor,
                width: 2,
              ),
            ),
            child: widget.isChecked
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null, // Show checkmark when checked
          ),
          const SizedBox(width: 8), // Space between the check box and the text
          widget.text, // Display the text next to the check box
        ],
      ),
    );
  }
}
