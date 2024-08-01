// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor:
                isPrimary ? AppTheme.primaryColor : AppTheme.textColor,
            side: BorderSide(
                color: isPrimary ? AppTheme.primaryColor : AppTheme.textColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          )
        : ElevatedButton.styleFrom(
            foregroundColor: isPrimary ? Colors.white : AppTheme.textColor,
            backgroundColor: isPrimary ? AppTheme.primaryColor : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          );

    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isOutlined
          ? (isPrimary ? AppTheme.primaryColor : AppTheme.textColor)
          : (isPrimary ? Colors.white : AppTheme.textColor),
    );

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
  }
}
