import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary
            ? Colors.white
            : (onPressed != null ? AppTheme.textColor : Colors.grey),
        backgroundColor: isPrimary
            ? (onPressed != null ? AppTheme.primaryColor : Colors.grey[300])
            : (onPressed != null ? AppTheme.backgroundColor : Colors.grey[300]),
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: Text(text),
    );
  }
}
