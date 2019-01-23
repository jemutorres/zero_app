import 'package:shared_preferences/shared_preferences.dart';

// Settings of zero
class SettingsZero {
  String ipServer;
  String defaultRepository;
  String defaultAcquireType;

  SettingsZero({this.ipServer, this.defaultRepository, this.defaultAcquireType});

  factory SettingsZero.fromJson(SharedPreferences _prefs) {
    return SettingsZero(
        ipServer: _prefs.getString('ipServer'),
        defaultRepository: _prefs.getString('defaultRepository'),
        defaultAcquireType: _prefs.getString('defaultAcquireType'));
  }
}