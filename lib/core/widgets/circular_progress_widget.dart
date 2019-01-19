import 'package:flutter/material.dart';

import 'package:zero/core/services/localizations_service.dart';

class CircularProgress extends StatelessWidget {
  CircularProgress({this.size: 80.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF145D8A))),
    );
  }
}

