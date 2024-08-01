// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_card.dart';
import 'theme/app_theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Brainer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              const CustomTextField(hintText: 'Search for a quiz'),
              const SizedBox(height: 24),
              const CustomCard(
                title: 'Daily Challenge',
                subtitle: 'Test your knowledge every day',
                icon: Icons.star,
              ),
              const SizedBox(height: 16),
              const CustomCard(
                title: 'My Progress',
                subtitle: 'View your learning stats',
                icon: Icons.trending_up,
              ),
              const Spacer(),
              CustomButton(
                text: 'Start a New Quiz',
                onPressed: () {
                  // TODO: Navigate to quiz screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
