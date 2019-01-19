import 'package:connectivity/connectivity.dart';

import 'package:zero/core/configuration.dart';

final WifiService wifiService = new WifiService._internal();

class WifiService {
  // Singleton service
  WifiService._internal();

  // Singleton constructor
  factory WifiService() {
    // Return singleton service
    return wifiService;
  }

  Future<bool> isConnectedToServer() async {
    try {
      // Get connectivity
      ConnectivityResult connectivityResult = await (new Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.wifi) {
        String wifiConnected = await (new Connectivity().getWifiName());

        if(wifiConnected == config['DEFAULT_ZERO_SERVER']['SSID']) {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  // TODO: Registrar subscripcion y enviar notifiacion si perdemos la conexión wifi
//  _initState() {
//    subscription = new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//      // Got a new connectivity status!
//    })
//  }
//
//// Be sure to cancel subscription after you are done
//  _dispose() {
//    subscription.cancel();
//  }

}