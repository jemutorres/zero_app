import 'package:flutter/material.dart';

class DeviceCardTitle extends StatelessWidget {
  final String name; // Name of the device
  final String size; // Size of the device

  DeviceCardTitle(this.name, this.size);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
                leading: new Icon(Icons.devices, size: 65),
                title: Text(name, textAlign: TextAlign.right),
                subtitle: Text(size, textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
