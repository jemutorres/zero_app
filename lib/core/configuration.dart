import 'package:flutter/material.dart';

const Map config = const {
  'DURATION_SPLASH_SCREEN': 5, // In seconds
  'LANGUAGES:': const {
    'VALUES': [
      const Locale('en', 'US'), // English
      const Locale('es', 'ES') // Spanish
    ],
    'DEFAULT': 'en',
  },
  'DEFAULT_ZERO_SERVER': const {
    'IP': '10.3.141.1', // Valid IP
    'SSID': 'TP-LINK_C3B6'
  },
  'API_CONFIG': const {
    'API_PROTOCOL': 'http', // Values: ['http', 'https']
    'API_PORT': 5000
  },
  'ACQUIRE_TYPE': const {
    'DEFAULT': 'E01',
    'VALUES': ['E01', 'DD']
  }
};