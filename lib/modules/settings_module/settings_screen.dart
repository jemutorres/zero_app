import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:zero/modules/settings_module/models/settings_model.dart';
import 'package:zero/core/models/repository_model.dart';
import 'package:zero/modules/settings_module/services/settings_api_service.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/circular_progress_widget.dart';
import 'package:zero/core/configuration.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Shared preferences of user
  SharedPreferences _prefs;

  // Key form state
  final GlobalKey<FormState> _settingsFormKey = new GlobalKey<FormState>();

  SettingsZero _settingsZero = new SettingsZero();

  Future<SettingsZero> getDefaultSettingsUser() async {
    // Get repositories
    List<Repository> repositoriesAvailables = await getRepositories();
    // Settings default
    SettingsZero defaultZero = new SettingsZero();
    // Default values of user
    String ipServer;
    String acquireType;
    String repository;

    // Get the values of user
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _prefs = sp;
      ipServer = _prefs.getString("settings_ipServer");
      acquireType = _prefs.getString("settings_acquireType");
      repository = _prefs.getString("settings_repository");

      defaultZero.ipServer =
          ipServer == null ? config['DEFAULT_ZERO_SERVER']['IP'] : ipServer;
      defaultZero.repositories =
          repositoriesAvailables.map((i) => i.mountPoint).toList();
      defaultZero.defaultRepository =
          defaultZero.repositories.contains(repository)
              ? repository
              : defaultZero.repositories.first;
      defaultZero.acquireTypes = config['ACQUIRE_TYPE']['VALUES'];
      defaultZero.defaultAcquireType =
          defaultZero.acquireTypes.contains(acquireType)
              ? acquireType
              : config['ACQUIRE_TYPE']['DEFAULT'];

      return defaultZero;
    });
  }

  AppBar getAppBar() {
    return AppBar(
      title: new Text(
        LocalizationsService.of(context).trans('screen_title_settings'),
        style: new TextStyle(
          fontSize:
              Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
    );
  }

  Widget buildBody() {
    return new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this._settingsFormKey,
          child: new ListView(
            children: <Widget>[
              getTextFormFieldIp(),
              getDropDownRepository(),
              getDropDownAcquireType(),
            ],
          ),
        ));
  }

  TextFormField getTextFormFieldIp() {
    return TextFormField(
        initialValue: this._settingsZero.ipServer,
        decoration: new InputDecoration(
            labelText: LocalizationsService.of(context)
                .trans('screen_settings_label_server_ip')),
        keyboardType: TextInputType.text,
        validator: this._validateBluetoothAddr,
        onSaved: (String value) {
          this._settingsZero.ipServer = value;
        });
  }

  DropdownButtonFormField<String> getDropDownRepository() {
    print(" SETTINGS_ZERO " + _settingsZero.toString());
    print(" SETTINGS_ZERO repositories " + _settingsZero.repositories.toString());
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(_settingsZero.repositories),
      onChanged: (String newValue) {
        setState(() {
          this._settingsZero.defaultRepository = newValue;
          this.submit();
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_settings_label_repository')),
      validator: this._validateRepository,
      value: this._settingsZero.defaultRepository,
    );
  }

  DropdownButtonFormField<String> getDropDownAcquireType() {
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(_settingsZero.acquireTypes),
      onChanged: (String newValue) {
        setState(() {
          this._settingsZero.defaultAcquireType = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_settings_label_acquire_type')),
      validator: this._validateAcquireType,
      value: this._settingsZero.defaultAcquireType,
    );
  }

  Container getSubmitButton() {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: new RaisedButton(
        child: new Text(
          'Save',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: this.submit,
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  Column buildErrorContainer() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            LocalizationsService.of(context)
                .trans('screen_settings_message_error'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ],
    );
  }

  String _validateBluetoothAddr(String value) {
    RegExp macExp = new RegExp(
        r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$');

    if (!macExp.hasMatch(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_server_ip');
    }
  }

  String _validateRepository(String value) {
    if (!this._settingsZero.repositories.contains(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_repository');
    }
  }

  String _validateAcquireType(String value) {
    if (!this._settingsZero.acquireTypes.contains(value)) {
      return LocalizationsService.of(context)
          .trans('screen_settings_message_validate_acquire_type');
    }
  }

  Widget getLoadingSettings() {
    // Show a loading spinner
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgress(),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                  LocalizationsService.of(context)
                      .trans('screen_settings_message_load'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15.0)),
            )
          ],
        ));
  }

  void submit() {
    // Validate form
    if (this._settingsFormKey.currentState.validate()) {
      saveUserPreferences();
    }
  }

  // Save user preferences
  void saveUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('settings_ipServer', _settingsZero.ipServer);
    prefs.setString('settings_repository', _settingsZero.defaultRepository);
    prefs.setString('settings_acquireType', _settingsZero.defaultAcquireType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: FutureBuilder<SettingsZero>(
          future: getDefaultSettingsUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !(snapshot.data == null)) {
              _settingsZero = _settingsZero == null ? snapshot.data : _settingsZero;
              return buildBody();
            } else if (snapshot.hasError) {
              return buildErrorContainer();
            }

            // Show a loading spinner
            return getLoadingSettings();
          },
        ));
  }
}
