import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/app_repository.dart';
import 'app_remote_datasource.dart';


final appRepositoryProvider = Provider<AppRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AppRepositoryImpl(AppRemoteDatasource(dio));
});


class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl(this._datasource);

  final AppRemoteDatasource _datasource;

  @override
  Future<AppStatusResponse> getAppStatus() => _datasource.getAppStatus();

  @override
  Future<AppVersionResponse> checkAppVersion({
    required AppPlatform platform,
    required String appVersion,
  }) =>
      _datasource.checkAppVersion(
        platform: platform,
        appVersion: appVersion,
      );
}