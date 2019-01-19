//import 'package:flutter/material.dart';
//
//import 'package:zero/core/core_inherited_widget.dart';
//import 'package:zero/core/models/notification_model.dart';
//
//class SnackBarWidget extends SnackBar {
//  SnackBarWidget();
//
//  @override
//  Widget build(BuildContext context) {
//
//    final CoreInheritedWidgetState state = CoreInheritedWidget.of(context);
//
//    Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text(state.notification.msg),
//        backgroundColor: Colors.amber,
//        duration: Duration(seconds: 3)
//    ));
//    // TODO: Cambiar color dependiendo del estado de la notificacion
//  }
//}
