import 'package:flutter/material.dart';

import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/utils/utils.dart';

import 'device_card_title.dart';
import 'device_card_status.dart';

class DeviceCard extends StatelessWidget {
  DeviceCard({Key key, this.scaffoldKey, this.device}) : super(key: key);
//  const DeviceCard(this.device);

  // Scaffold key from parent
  final GlobalKey<ScaffoldState> scaffoldKey;

  // The device of the card
  final Device device;

  // Build the subtitle with the size
  String _getSubtitleSize() {
    String sUsed = this.device.sizeUsed == -1
        ? ''
        : CoreUtils.getFilesize(this.device.sizeUsed) + ' / ';
    String sTotal = CoreUtils.getFilesize(this.device.sizeTotal);

    return sUsed + sTotal;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: new SizedBox(
          height: 165.0,
          child: new Card(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new DeviceCardTitle(device.name, _getSubtitleSize()),
                    new DeviceCardStatus(scaffoldKey: this.scaffoldKey, device: device),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
