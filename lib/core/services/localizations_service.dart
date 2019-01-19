import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationsService {
  LocalizationsService(this.locale);

  final Locale locale;

  static LocalizationsService of(BuildContext context) {
    return Localizations.of<LocalizationsService>(context, LocalizationsService);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data = await rootBundle.loadString('resources/lang/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}

class LocalizationsServiceDelegate extends LocalizationsDelegate<LocalizationsService> {
  const LocalizationsServiceDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<LocalizationsService> load(Locale locale) async {
    LocalizationsService localizations = new LocalizationsService(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(LocalizationsServiceDelegate old) => false;
}