import 'package:flutter/material.dart';

import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/widgets/circular_progress_widget.dart';

Widget getLoadingMessage(BuildContext context, String text) {
  // Show a loading spinner
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new CircularProgress(),
      Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(LocalizationsService.of(context).trans(text),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      )
    ],
  ));
}

Widget getMessage(BuildContext context, String text) {
  return new Container(
      child: new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(LocalizationsService.of(context).trans(text),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
    ],
  ));
}
