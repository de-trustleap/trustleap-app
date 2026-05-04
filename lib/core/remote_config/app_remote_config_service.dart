import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppRemoteConfigService {
  final _rc = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _rc.setDefaults({'tremendous_enabled': false});
    await _rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    try {
      await _rc.fetchAndActivate();
    } catch (_) {}
  }

  Future<void> activate() => _rc.activate();

  bool get tremendousEnabled => _rc.getBool('tremendous_enabled');

  Stream<void> get onConfigUpdated => _rc.onConfigUpdated.map((_) {});
}
