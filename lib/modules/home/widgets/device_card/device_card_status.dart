import 'package:flutter/material.dart';
import 'dart:async';

import 'package:zero/core/core_inherited_widget.dart';
import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/models/notification_model.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/services/navigator_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/circular_progress_widget.dart';
import 'package:zero/core/widgets/snackbar_widget.dart';
import 'package:zero/modules/home/services/device_service.dart';

class DeviceCardStatus extends StatefulWidget {
  DeviceCardStatus({Key key, this.scaffoldKey, this.device}) : super(key: key);

  // Scaffold key from parent
  final GlobalKey<ScaffoldState> scaffoldKey;

  // Device of the card
  final Device device;

  @override
  _DeviceCardStatusState createState() =>
      new _DeviceCardStatusState(this.device);
}

class _DeviceCardStatusState extends State<DeviceCardStatus> {
  _DeviceCardStatusState(this.device);

  // Device of the card
  final Device device;

  // InheritedWidget state to change status of the device
  CoreInheritedWidgetState state;

  // Device status
  DeviceStatus status = DeviceStatus(operation: DeviceOperation.WAITING);

  // Timer
  Timer statusTimer;

  // Variable define if it's processing
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Call method to get the device status
    _updateDeviceStatus();
  }

  @override
  void dispose() {
    // Stop timer
    _stopTimer();
    super.dispose();
  }

  // Method to reload the status every 5 seconds
  _updateTimer(Timer t) {
    _updateDeviceStatus();
  }

  // Get the device status
  _updateDeviceStatus() async {
    DeviceStatus statusResponse;

    switch (status.operation) {
      case DeviceOperation.WAITING:
        statusResponse = await getStatusDevice(device.name);
        break;
      case DeviceOperation.ACQUIRING:
        statusResponse = await getAcquireStatus(status.id);
        break;
      case DeviceOperation.RUNNING_MODULE:
        statusResponse = await getModuleStatus(status.id);
        break;
    }

    // Only reload widget if change status
    if (!(statusResponse == status)) {
      reloadCards(statusResponse);
    }
  }

  // Init timer to reload status
  _initTimer() {
    if (statusTimer == null || !statusTimer.isActive) {
      // Init timer
      statusTimer = new Timer.periodic(new Duration(seconds: 5), _updateTimer);
      // Variable to control if it's processing
      isProcessing = true;
    }
  }

  // Stop timer
  _stopTimer() {
    if (statusTimer != null && statusTimer.isActive) {
      statusTimer.cancel();
      // Variable to control if it's processing
      isProcessing = false;
    }
  }

  // This method control if it's necesary to initTimer to reload status if device is processing
  // When operation finish, send notification to main screen
  void reloadCards(DeviceStatus response) {
    setState(() {
      // If state is running and new state it's different of it
      if (status.operation != DeviceOperation.WAITING &&
          response.operation == DeviceOperation.WAITING) {
        // If execution of module finish ok, save the id on the device
        if (status.operation == DeviceOperation.RUNNING_MODULE &&
            response.operationStatus == DeviceServerStatus.FINISHED) {
          device.setResultModule(status.module, status.id);
        }

        // Send notification
        sendNotification(status.operation, response.operationStatus, status.module);
      }

      // Change status
      status = response;

      if (status.operation != DeviceOperation.WAITING) {
        _initTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void sendNotification(DeviceOperation operation, DeviceServerStatus status, String module) {
    String message;
    // Get message
    switch(operation) {
      case DeviceOperation.ACQUIRING:
        message = LocalizationsService.of(context)
            .trans('widget_device_card_label_device_acquire_finished') + device.name;
        break;
      case DeviceOperation.RUNNING_MODULE:
        message = CoreUtils.capitalizeFirstLetter(module) + LocalizationsService.of(context)
            .trans('widget_device_card_label_device_running_module_finished') + device.name;
        break;
      default:
        message = "";
        break;
    }

    NotificationAppStatus notStatus = (status == DeviceServerStatus.FINISHED)
        ? NotificationAppStatus.SUCESS
        : NotificationAppStatus.FAILED;
    
    // Send notification
    widget.scaffoldKey.currentState.showSnackBar(SnackBarWidget(context, new NotificationApp(message, notStatus)));
  }

  // Build the body depend the status
  Widget buildBody() {
    if (this.status == null ||
        this.status.operation != DeviceOperation.WAITING) {
      return buildProcessingContainer();
    } else {
      return buildButtonContainer();
    }
  }

  // Return the container of processing
  Widget buildProcessingContainer() {
    String text = getTextStatus(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new CircularProgress(size: 30.0),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Text(text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
        )
      ],
    );
  }

  // Return the text depend the operation
  String getTextStatus(context) {
    switch (this.status.operation) {
      case DeviceOperation.ACQUIRING:
        return LocalizationsService.of(context)
                .trans('widget_device_card_label_device_acquiring') +
            ' ' +
            this.status.progress.toString() +
            '%';
        break;
      case DeviceOperation.RUNNING_MODULE:
        return LocalizationsService.of(context)
            .trans('widget_device_card_label_device_running_module');
        break;
      default:
        return "";
    }
  }

  // Acquire the device
  void acquire() async {
    // Run acquire and
    DeviceStatus acquireStatus = await acquireDevice(this.device);
    // Call method to decide if it's necessary reload card
    reloadCards(acquireStatus);
  }

  // Go to forensic list and get the status
  void processModule() async {
    // Get the return of window
    DeviceStatus processStatus =
        await NavigatorService.goToModuleList(context, this.device.name);

    if (processStatus != null) {
      // Call method to decide if it's necessary reload card
      reloadCards(processStatus);
    }
  }

  // Go to forensic result
  void resultsModule() {
    // Navigate to results
    NavigatorService.goToResultModuleList(context, this.device);
  }

  // Return the container of buttons
  Widget buildButtonContainer() {
    return ButtonTheme.bar(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(LocalizationsService.of(context)
                .trans('widget_device_card_button_acquire')),
            onPressed:
                // Visible where device it's processing and server have repositories
                // TODO: Cambiar a !state.hasrepositories cuando Javi arregle lo suyo
                state.hasRepositories || isProcessing
                    ? null
                    : () {
                        // Do acquisition
                        acquire();
                      },
          ),
          FlatButton(
            child: Text(LocalizationsService.of(context)
                .trans('widget_device_card_button_process')),
            onPressed: () {
              // Load list modules window
              processModule();
            },
          ),
          FlatButton(
            child: Text(LocalizationsService.of(context)
                .trans('widget_device_card_button_results')),
            onPressed:
                // Visible where device have results
                !this.device.existResults()
                    ? null
                    : () {
                        // Load results window
                        resultsModule();
                      },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get state of inheritedwidget
    state = CoreInheritedWidget.of(context);
    print("repintando status de dispositivo " + device.name);

    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[buildBody()],
      ),
    );
  }
}
