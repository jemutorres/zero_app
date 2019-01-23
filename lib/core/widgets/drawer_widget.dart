import 'package:flutter/material.dart';

import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/services/navigator_service.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: new Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: new AssetImage(
                          "resources/images/zero_logo_splash_white.png"),
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
          new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text(LocalizationsService.of(context)
                  .trans('screen_home_list_view_settings')),
              onTap: () {
                NavigatorService.goToSettings(context);
              }),
          // TODO: FUNCIONALIDAD 2: HACER UN LISTVIEW BUILDER Y COLOCAR LOS BOTONES DE APAGAR AL FINAL
          // FUNCIONALIDAD 2: Agregar apagado de la raspberry y cierre de la aplicación.
//          new Divider(),
//          new ListTile(
//              leading: new Icon(Icons.exit_to_app),
//              title: new Text(LocalizationsService.of(context)
//                  .trans('screen_home_list_view_exit')),
//              onTap: () {
//  //              Navigator.pop(context);
//              }),
//          new ListTile(
//              leading: new Icon(Icons.settings_power),
//              title: new Text(LocalizationsService.of(context)
//                  .trans('screen_home_list_view_exit_shutdown')),
//              onTap: () async {
//  //              bool isShutdown = await shutdownServer();
////                if (isShutdown) {
////                  Navigator.pop(context);
////                } else {
////                show
////                }
//              }),
      ],
    ));
  }
}
