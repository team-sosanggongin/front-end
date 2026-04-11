import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/app_repository_impl.dart';
import '../domain/app_repository.dart';


final appControllerProvider =
StateNotifierProvider<AppController, AsyncValue<AppCheckResult>>((ref) {
  return AppController(ref.read(appRepositoryProvider));
});


sealed class AppCheckResult {}

class AppCheckOk extends AppCheckResult {}

class AppCheckMaintenance extends AppCheckResult {
  AppCheckMaintenance({
    required this.reason,
    this.startedAt,
    this.endedAt,
  });

  final String reason;
  final String? startedAt;
  final String? endedAt;
}

class AppCheckForceUpdate extends AppCheckResult {
  AppCheckForceUpdate({
    required this.latestVersion,
    this.reason,
  });

  final String latestVersion;
  final String? reason;
}

class AppCheckOptionalUpdate extends AppCheckResult {
  AppCheckOptionalUpdate({
    required this.latestVersion,
    this.reason,
  });

  final String latestVersion;
  final String? reason;
}


class AppController extends StateNotifier<AsyncValue<AppCheckResult>> {
  AppController(this._repository) : super(const AsyncLoading()) {
    _check();
  }

  final AppRepository _repository;

  Future<void> _check() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_runCheck);
  }

  Future<AppCheckResult> _runCheck() async {
    //점검 상태
    final status = await _repository.getAppStatus();
    if (status.underMaintenance) {
      return AppCheckMaintenance(
        reason: status.reason ?? '',
        startedAt: status.startedAt,
        endedAt: status.endedAt,
      );
    }

    //버전 체크
    final info = await PackageInfo.fromPlatform();
    final platform = Platform.isAndroid ? AppPlatform.android : AppPlatform.ios;

    final version = await _repository.checkAppVersion(
      platform: platform,
      appVersion: info.version,
    );

    if (!version.compatible || version.forceUpdateRequired) {
      return AppCheckForceUpdate(
        latestVersion: version.latestVersion ?? '',
        reason: version.reason,
      );
    }

    if (version.latestVersion != null &&
        version.latestVersion != info.version) {
      return AppCheckOptionalUpdate(
        latestVersion: version.latestVersion!,
        reason: version.reason,
      );
    }

    return AppCheckOk();
  }

  /// 스플래시 재시도
  Future<void> retry() => _check();
}