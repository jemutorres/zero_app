import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zero/core/configuration.dart';
import 'package:zero/core/screens/splash_screen.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/services/api_service.dart';
import 'package:zero/core/styles/theme.dart';

void main() {
  runApp(new ZeroApp());
}

class ZeroApp extends StatelessWidget {
  void runServices() {
    // Build singleton services
    apiService.init();
  }

  @override
  Widget build(BuildContext context) {
    // Run the singleton modules and singleton services
    runServices();

    return new MaterialApp(
      // Set Zero theme
      theme: ZeroThemeDark,
      // Load splash screen at init
      home: SplashScreen(),
      // Load localizations services
      localizationsDelegates: [
        LocalizationsServiceDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Get supported languages
      supportedLocales: config['LANGUAGES:']['VALUES'],
      // Load the default language
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == config['LANGUAGES:']['DEFAULT']) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
