// lib/widgets/spotify_card.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpotifyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SpotifyCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: AppTheme.primaryColor),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTheme.bodyStyle
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(subtitle, style: AppTheme.captionStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
