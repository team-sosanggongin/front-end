import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

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
    final rs = ResponsiveSize.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: rs.px(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: rs.h(8)),
                    Text(title, style: AppTextStyles.heading),
                    SizedBox(height: rs.h(8)),
                    Text(subtitle, style: AppTextStyles.subtitle),
                    SizedBox(height: rs.h(32)),
                    body,
                  ],
                ),
              ),
            ),
            if (bottomButton != null)
              Padding(
                padding: rs.fromLTRB(24, 0, 24, 24),
                child: bottomButton!,
              ),
          ],
        ),
      ),
    );
  }
}
