import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AuthPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final Widget? bottomButton;

  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(title, style: AppTextStyles.heading),
                    const SizedBox(height: 8),
                    Text(subtitle, style: AppTextStyles.subtitle),
                    const SizedBox(height: 32),
                    body,
                  ],
                ),
              ),
            ),
            if (bottomButton != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: bottomButton!,
              ),
          ],
        ),
      ),
    );
  }
}
