import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';

import 'package:zero/core/models/device_model.dart';

import 'package:zero/modules/home/home_screen.dart';
import 'package:zero/modules/forensic_list_module/forensic_list_screen.dart';
import 'package:zero/modules/forensic_results_module/forensic_results_screen.dart';
import 'package:zero/modules/settings_module/settings_screen.dart';

class NavigatorService {
  static void goToHome(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => HomeScreen());
    Navigator.pushReplacement(context, route);
  }

  static Future<DeviceStatus> goToModuleList(
      BuildContext context, String deviceName) async {
    Route route =
        MaterialPageRoute(builder: (context) => ForensicModulesScreen(deviceName));
    final result = await Navigator.of(context).push(route);

    return result;
  }

  static void goToResultModuleList(BuildContext context, Device device) {
    Route route = MaterialPageRoute(builder: (context) => ForensicResultsScreen(device));
    Navigator.of(context).push(route);
  }

  static void goToSettings(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => SettingsScreen());
    Navigator.of(context).push(route);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void goToAndroidSettings() {
    final AndroidIntent intent =
        new AndroidIntent(action: 'android.settings.WIFI_SETTINGS');
    intent.launch();
  }
}
