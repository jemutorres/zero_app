import 'package:flutter/material.dart';

import 'package:zero/core/models/notification_model.dart';
import 'package:zero/core/services/localizations_service.dart';

SnackBar SnackBarWidget(BuildContext context, NotificationApp notification) {
  // TODO: Cambiar color dependiendo del estado de la notificacion
  String label;
  Color textLabelColor;

  switch(notification.notificationStatus) {
    case NotificationAppStatus.SUCESS:
      label = LocalizationsService.of(context)
          .trans('widget_snackbar_success');
      textLabelColor = Colors.blue;
      break;
    case NotificationAppStatus.FAILED:
      label = LocalizationsService.of(context)
          .trans('widget_snackbar_failed');
      textLabelColor = Colors.red;
      break;
  }


  return new SnackBar(
      content: new Text(notification.msg),
      action: SnackBarAction(
        label: label,
        textColor: textLabelColor,
        onPressed: () {
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2));
}
