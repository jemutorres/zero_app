import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:zero/core/models/settings_model.dart';
import 'package:zero/core/configuration.dart';
import 'package:zero/core/models/response_model.dart';

final SharedPreferencesService sharedPreferencesService = new SharedPreferencesService._internal();

class SharedPreferencesService {
  // Singleton service
  SharedPreferencesService._internal();

  // Singleton constructor
  factory SharedPreferencesService() {
    // Return singleton service
    return sharedPreferencesService;
  }
  // Shared preferences of user
  SharedPreferences _prefs;

  // Load the values from user
  Future init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print(e);
    }
  }

  // Get value from preferences
  Future<String> getValue(String key) async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    return _prefs.getString(key) != null ? _prefs.getString(key) : null;
  }

  // Get all settings
  Future<SettingsZero> getSettings() async {
    try {
      return SettingsZero.fromJson(_prefs);
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveNewSettings(SettingsZero newSettings) async {
    try {
      // Save new settings
      _prefs.setString('ipServer', newSettings.ipServer);
      _prefs.setString('defaultAcquireType', newSettings.defaultAcquireType);
      _prefs.setString('defaultRepository', newSettings.defaultRepository);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get the ip
  Future<String> getIp() async {
    String ipUser = await getValue('ipServer');
    return ipUser != null ? ipUser : config['DEFAULT_ZERO_SERVER']['IP'];
  }

  // Get the acquire type
  Future<String> getDefaultAcquireType() async {
    String defaultAcquireType = await getValue('defaultAcquireType');
    return defaultAcquireType != null ? defaultAcquireType : config['ACQUIRE_TYPE']['DEFAULT'];
  }

}