import 'package:flutter/material.dart';
import 'dart:async';

import 'package:zero/core/core_inherited_widget.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/widgets/app_bar_widget.dart';
import 'package:zero/core/widgets/drawer_widget.dart';

import 'widgets/list_cards_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Home Scaffold key
  final GlobalKey<ScaffoldState> homeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // TODO: COMPROBAR EL FUNCIONAMIENTO. NO DEVUELVE EL SSID
  }

  // TODO: Abstraer el showDialog a un componente y reutilizar pasando los argumentos necesarios
  Future<bool> _onCloseApp() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text(LocalizationsService.of(context)
                    .trans('screen_home_dialog_exit_title')),
                content: new Text(LocalizationsService.of(context)
                    .trans('screen_home_dialog_exit_content')),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(LocalizationsService.of(context)
                        .trans('screen_home_dialog_exit_cancel')),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text(LocalizationsService.of(context)
                        .trans('screen_home_dialog_exit_yes')),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    print("repintando home");
    // Implement inheritedwidget
    return CoreInheritedWidget(
        child: WillPopScope(
            onWillPop: () => _onCloseApp(),
            // Call function if back button is pressed
            child: new Scaffold(
                key: homeScaffoldKey, // Scaffold key
                appBar: AppBarWidget(), // Get the appbar
                drawer: DrawerWidget(), // Get the leftside drawer
                body: new PageView(children: <Widget>[
                  new ListCardsWidget(), // Get the list of cards
                  // TODO: Agregar snackbar con notificaciones
                ]))));
  }
}
