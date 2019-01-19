import 'package:flutter/material.dart';

import 'package:zero/core/services/localizations_service.dart';

Future<bool> showDialogComponentText(BuildContext context, String title, String textContent, String leftButton, String rightButton, Function leftAction, Function rightAction) {
  // Create the text widget
  Widget content = new Text(LocalizationsService.of(context).trans(textContent));
  return showDialogComponent(context, title, content, leftButton, rightButton, leftAction, rightAction);
}

Future<bool> showDialogComponent(BuildContext context, String title, Widget content, String leftButton, String rightButton, VoidCallback leftAction, VoidCallback rightAction) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text(LocalizationsService.of(context)
          .trans(title)),
      content: content,
      actions: <Widget>[
        new FlatButton(
          child: new Text(LocalizationsService.of(context)
              .trans(leftButton)),
          onPressed: () => leftAction,
        ),
        new FlatButton(
          child: new Text(LocalizationsService.of(context)
              .trans(rightButton)),
          onPressed: () => rightAction,
        ),
      ],
    ),
  );
}

