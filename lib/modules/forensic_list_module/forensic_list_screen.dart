import 'package:flutter/material.dart';

import 'package:zero/core/components/message_container_component.dart';
import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/app_bar_widget.dart';
import 'package:zero/modules/home/services/device_service.dart';

class ForensicModulesScreen extends StatefulWidget {
  ForensicModulesScreen(this.deviceName);

  final String deviceName;

  @override
  _ForensicModulesState createState() => _ForensicModulesState(this.deviceName);
}

class _ForensicModulesState extends State<ForensicModulesScreen> {
  _ForensicModulesState(this.deviceName);

  // Key form state
  final GlobalKey<FormState> modulesListFormKey = new GlobalKey<FormState>();

  // Device to execute module
  final String deviceName;

  // Dropdown value
  String selectedModule;

  // List of forensic modules
  List<String> modules;

  Widget buildBody() {
    return new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this.modulesListFormKey,
          child: new ListView(
            children: <Widget>[getDropDownModules(), getRunButton()],
          ),
        ));
  }

  DropdownButtonFormField<String> getDropDownModules() {
    // Set selected module
    this.selectedModule =
        this.selectedModule == null ? this.modules.first : this.selectedModule;

    // Return the dropdownbutton
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(this.modules),
      onChanged: (String newValue) {
        setState(() {
          this.selectedModule = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_forensic_modules_label_modules')),
      value: this.selectedModule,
    );
  }

  // Return run button
  Container getRunButton() {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: new RaisedButton(
        child: new Text(
          LocalizationsService.of(context)
              .trans('screen_forensic_modules_button_run'),
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          // Run module and return
          DeviceStatus deviceStatus = await runModule(this.deviceName, this.selectedModule);
          Navigator.pop(context, deviceStatus);
        },
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTextWidget(context, 'screen_title_forensic_modules'),
        body: FutureBuilder<List<String>>(
          future: getForensicModules(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              modules = snapshot.data;
              if (modules.length > 0) {
                // Return body
                return buildBody();
              } else {
                // Return empty modules
                return getMessage(context, 'screen_forensic_modules_message_not_modules');
              }
            } else if (snapshot.hasError) {
              // Return error message
              return getMessage(context, 'screen_forensic_modules_message_error');
            }
            // Return loading message
            return getLoadingMessage(context, 'screen_forensic_modules_message_load');
          },
        ));
  }
}
