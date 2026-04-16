import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

// 서비스 체크
sealed class AppCheckResult {}

class AppCheckOk extends AppCheckResult {}

class AppCheckMaintenance extends AppCheckResult {
  AppCheckMaintenance({required this.reason, this.startedAt, this.endedAt});
  final String reason;
  final String? startedAt;
  final String? endedAt;
}

class AppCheckForceUpdate extends AppCheckResult {
  AppCheckForceUpdate({required this.latestVersion, this.reason});
  final String latestVersion;
  final String? reason;
}

class AppCheckOptionalUpdate extends AppCheckResult {
  AppCheckOptionalUpdate({required this.latestVersion, this.reason});
  final String latestVersion;
  final String? reason;
}

// API
abstract class _AppApiPath {
  static const status = 'api/v1/app/status';
  static const versionCheck = 'api/v1/app/version-check';
}

// Provider

final appCheckProvider =
StateNotifierProvider<AppCheckNotifier, AsyncValue<AppCheckResult>>((ref) {
  return AppCheckNotifier(ref.read(dioProvider));
});

// Notifier
class AppCheckNotifier extends StateNotifier<AsyncValue<AppCheckResult>> {
  AppCheckNotifier(this._dio) : super(const AsyncLoading()) {
    _check();
  }

  final Dio _dio;

  Future<void> _check() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_runCheck);
  }

  Future<AppCheckResult> _runCheck() async {
    // Mock 환경이면 바로 통과
    if (EnvConfig.isMock) return AppCheckOk();

    // 1) 점검 상태
    final statusRes = await _dio.get(_AppApiPath.status);
    final status = statusRes.data as Map<String, dynamic>;
    if (status['underMaintenance'] == true) {
      return AppCheckMaintenance(
        reason: status['reason'] as String? ?? '',
        startedAt: status['startedAt'] as String?,
        endedAt: status['endedAt'] as String?,
      );
    }

    // 2) 버전 체크
    final info = await PackageInfo.fromPlatform();
    final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
    final versionRes = await _dio.post(
      _AppApiPath.versionCheck,
      data: {'platform': platform, 'appVersion': info.version},
    );
    final version = versionRes.data as Map<String, dynamic>;

    if (version['compatible'] == false || version['forceUpdateRequired'] == true) {
      return AppCheckForceUpdate(
        latestVersion: version['latestVersion'] as String? ?? '',
        reason: version['reason'] as String?,
      );
    }

    if (version['latestVersion'] != null &&
        version['latestVersion'] != info.version) {
      return AppCheckOptionalUpdate(
        latestVersion: version['latestVersion'] as String,
        reason: version['reason'] as String?,
      );
    }

    return AppCheckOk();
  }

  Future<void> retry() => _check();
}