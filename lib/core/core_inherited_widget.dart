import 'package:flutter/material.dart';

import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/models/notification_model.dart';

class _CoreInherited extends InheritedWidget {
  _CoreInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final CoreInheritedWidgetState data;

  @override
  bool updateShouldNotify(_CoreInherited oldWidget) {
    return true;
  }
}

class CoreInheritedWidget extends StatefulWidget {
  CoreInheritedWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  CoreInheritedWidgetState createState() => new CoreInheritedWidgetState();

  static CoreInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_CoreInherited)
            as _CoreInherited)
        .data;
  }
}

class CoreInheritedWidgetState extends State<CoreInheritedWidget> {
  // List devices
  List<Device> devices;

  // Bool to define if have repositories
  bool hasRepositories;

  // HELP: In all method call setState to rebuild the childrens suscribed to inherited widget

  // Change the list of devices
  void changeDevicesList(List<Device> devices) {
    setState(() {
      this.devices = devices;
    });
  }

  // Change repositories
  void changeRepositories(bool hasRepositories) {
    setState(() {
      this.hasRepositories = hasRepositories;
    });
  }

  // Change the list of devices
  void changeStatusDevice(Device device, DeviceStatus status) {
    // Change the status but not reload. The status is reloading by another widget
    for (Device dev in this.devices) {
      if (device == dev) {
        dev.status = status;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _CoreInherited(child: widget.child, data: this);
  }
}
