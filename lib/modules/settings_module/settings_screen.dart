import 'package:flutter/material.dart';

import 'package:zero/core/configuration.dart';
import 'package:zero/core/components/message_container_component.dart';
import 'package:zero/core/models/notification_model.dart';
import 'package:zero/core/models/settings_model.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/services/shared_preferences_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/app_bar_widget.dart';
import 'package:zero/core/widgets/snackbar_widget.dart';

import 'services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // Settings Scaffold key
  final GlobalKey<ScaffoldState> _settingsScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // Key form state
  final GlobalKey<FormState> _settingsFormKey = new GlobalKey<FormState>();

  // Default settings of user
  SettingsZero _settingsZero;

  // List of repositories
  List<String> repositories;

  // List of acquisition types
  List<String> acquisitionsTypes;

  @override
  void initState() {
    super.initState();
  }

  Future<SettingsZero> getDefaultSettingsUser() async {
    // Get acquisitions types from config
    acquisitionsTypes = config['ACQUIRE_TYPE']['VALUES'];
    // Get repositories from server
    repositories = await getRepositoriesName();
    // Get values saved from the user
    SettingsZero settings = await sharedPreferencesService.getSettings();

    // Set actual values
    // Set IP
    settings.ipServer = settings.ipServer == null
        ? config['DEFAULT_ZERO_SERVER']['IP']
        : settings.ipServer;

    // Set acquisition type
    settings.defaultAcquireType = settings.defaultAcquireType == null
        ? config['ACQUIRE_TYPE']['DEFAULT']
        : settings.defaultAcquireType;
    // Set repository
    settings.defaultRepository = (repositories != null &&
            repositories.contains(settings.defaultRepository))
        ? settings.defaultRepository
        : repositories.first;

    return settings;
  }

  Widget buildBody() {
    return new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this._settingsFormKey,
          child: new ListView(
            children: <Widget>[
              // TODO: FUNCIONALIDAD 1.
              // FUNCIONALIDAD 1: De momento vamos a dejar la configuración de la IP debido a que este cambio conlleva un reinicio de la aplicación y una comprobación de conexión a la nueva IP previa.
              //getTextFormFieldIp(),
              getDropDownRepository(),
              getDropDownAcquireType(),
              getSubmitButton()
            ],
          ),
        ));
  }

  TextFormField getTextFormFieldIp() {
    return TextFormField(
        initialValue: _settingsZero.ipServer,
        decoration: new InputDecoration(
            labelText: LocalizationsService.of(context)
                .trans('screen_settings_label_server_ip')),
        keyboardType: TextInputType.text,
        validator: this._validateIp);
  }

  DropdownButtonFormField<String> getDropDownRepository() {
//    if(this.repositories != null) {
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(this.repositories),
      onChanged: (String newValue) {
        setState(() {
          _settingsZero.defaultRepository = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_settings_label_repository')),
      validator: this._validateRepository,
      value: _settingsZero.defaultRepository,
    );
//    }
  }

  DropdownButtonFormField<String> getDropDownAcquireType() {
//    if(this.acquisitionsTypes != null) {
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(this.acquisitionsTypes),
      onChanged: (String newValue) {
        setState(() {
          _settingsZero.defaultAcquireType = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_settings_label_acquire_type')),
      validator: this._validateAcquireType,
      value: _settingsZero.defaultAcquireType,
    );
//    }
  }

  Container getSubmitButton() {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: new RaisedButton(
        child: new Text(
          LocalizationsService.of(context).trans('screen_settings_button_save'),
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: this.submit,
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  String _validateIp(String value) {
    RegExp macExp = new RegExp(
        r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$');

    if (!macExp.hasMatch(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_server_ip');
    } else {
      _settingsZero.ipServer = value;
    }
  }

  String _validateRepository(String value) {
    if (!this.repositories.contains(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_repository');
    }
  }

  String _validateAcquireType(String value) {
    if (!this.acquisitionsTypes.contains(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_acquire_type');
    }
  }

  void submit() {
    // Validate form
    if (this._settingsFormKey.currentState.validate()) {
      saveUserPreferences();
    }
  }

  // Save user preferences
  void saveUserPreferences() async {
    bool isSaved =
        await sharedPreferencesService.saveNewSettings(_settingsZero);

    String msg;
    NotificationAppStatus status;

    if (isSaved) {
      msg = LocalizationsService.of(context)
          .trans('screen_settings_button_settings_saved');
      status = NotificationAppStatus.SUCESS;
    } else {
      msg = LocalizationsService.of(context)
          .trans('screen_settings_button_settings_saved_error');
      status = NotificationAppStatus.SUCESS;
    }

    // Show notification snackbar
    this._settingsScaffoldKey.currentState.showSnackBar(
        SnackBarWidget(context, new NotificationApp(msg, status)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _settingsScaffoldKey,
        appBar: AppBarTextWidget(context, 'screen_title_settings'),
        body: FutureBuilder<SettingsZero>(
          future: getDefaultSettingsUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !(snapshot.data == null)) {
              _settingsZero =
                  _settingsZero == null ? snapshot.data : _settingsZero;
              return buildBody();
            } else if (snapshot.hasError) {
              return getMessage(context, 'screen_settings_message_error');
            }

            // Show a loading spinner
            return getLoadingMessage(context, 'screen_settings_message_load');
          },
        ));
  }
}
