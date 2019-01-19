import 'package:flutter/material.dart';
import 'dart:async';

import 'package:zero/core/configuration.dart';
import 'package:zero/core/services/navigator_service.dart';
import 'package:zero/core/widgets/circular_progress_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: GET_STARTED
    // 1. Comprobamos de las preferencias de usuario si ha leido el get started
    //    - Si: Ventana home
    //    - Si no: abrimos get_stated
    Timer(Duration(seconds: config['DURATION_SPLASH_SCREEN']), () => NavigatorService.goToHome(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image(
                        image: new AssetImage(
                            "resources/images/zero_logo_splash_white.png"),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[new CircularProgress()],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
