import 'package:flutter/material.dart';

import 'package:zero/core/services/localizations_service.dart';

AppBar AppBarWidget() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          'resources/images/zero_logo_white.png',
          fit: BoxFit.fitHeight,
          height: 32,
        ),
      ],
    ),
  );
}

AppBar AppBarTextWidget(BuildContext context, String title) {
  return AppBar(
    title: new Text(
      LocalizationsService.of(context).trans(title),
      style: new TextStyle(
        fontSize:
        Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
      ),
    ),
    elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
  );
}