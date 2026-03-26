import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/home_footer.dart';
import 'widgets/home_header.dart';

class HomeShellLayout extends StatelessWidget {
  final Widget child;

  const HomeShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isRoot = location == '/home';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(isRoot: isRoot),
            Expanded(child: child),
            const HomeFooter(),
          ],
        ),
      ),
    );
  }
}
