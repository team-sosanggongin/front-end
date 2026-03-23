import 'package:flutter/material.dart';
import '../../utils/env_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push Notification MVP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text('현재 환경: ${EnvConfig.defaultEnv.name}'),
            const Text('알림 서비스가 실행 중입니다.'),
          ],
        ),
      ),
    );
  }
}
