import 'package:flutter/material.dart';
import 'dart:async';

import 'package:zero/core/core_inherited_widget.dart';
import 'package:zero/core/components/message_container_component.dart';

import 'package:zero/core/models/device_model.dart';
import 'package:zero/modules/home/services/device_service.dart';
import 'package:zero/core/utils/utils.dart';

import 'device_card/device_card.dart';

class ListCardsWidget extends StatefulWidget {
  ListCardsWidget({Key key, this.scaffoldKey}) : super(key: key);

  // Scaffold key from parent
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ListCardsWidgetState createState() => _ListCardsWidgetState();
}

class _ListCardsWidgetState extends State<ListCardsWidget> with WidgetsBindingObserver {
  // InheritedWidget state to set devices
  CoreInheritedWidgetState state;

  // Timer
  Timer devicesTimer;

  @override
  void initState() {
    super.initState();
    // Add the observer
    WidgetsBinding.instance.addObserver(this);
    // Init the timer
    _initTimer();
  }

  @override
  void dispose() {
    // Stop the timer
    _stopTimer();
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      // Init the timer when app it's visible
      case AppLifecycleState.resumed:
        _initTimer();
        break;
      // Stop the timer when app it's inactive
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
      case AppLifecycleState.paused:
        _stopTimer();
        break;
    }
  }

  // Method to reload the devices every 5 seconds
  _updateTimer(Timer t) {
    _updateDeviceCardList();
  }

  // Get the device list
  _updateDeviceCardList() async {
    List<Device> devicesList = await getDeviceResponse();
    bool repositories = await hasRepositories();

    if (!CoreUtils.compareListObjects(state.devices, devicesList)) {
      state.changeDevicesList(devicesList);
    }

    if (state.hasRepositories != repositories) {
      state.changeRepositories(repositories);
    }
  }

  // Init timer to reload status
  _initTimer() {
    if (devicesTimer == null || !devicesTimer.isActive) {
      // Init timer
      print("iniciando timer");
      devicesTimer = new Timer.periodic(new Duration(seconds: 5), _updateTimer);
    }
  }

  // Stop timer
  _stopTimer() {
    if (devicesTimer != null && devicesTimer.isActive) {
      print("parando timer");
      devicesTimer.cancel();
    }
  }

  // Build body with cards
  Widget buildBody(List<Device> items) {
    // Return list
    return new Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 5.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return DeviceCard(scaffoldKey: widget.scaffoldKey, device: items[index]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    print("repintando lista");

    // Get state of inheritedwidget
    state = CoreInheritedWidget.of(context);

    // Get the devices from the state
    List<Device> items = state.devices;

    if (items == null) {
      // Return loading message
      return getLoadingMessage(context, 'screen_home_message_load_devices');
    } else if (items.length == 0) {
      // Return no devices message
      return getMessage(context, 'screen_home_message_not_devices');
    } else {
      // Return body
      return buildBody(items);
    }
  }
}
