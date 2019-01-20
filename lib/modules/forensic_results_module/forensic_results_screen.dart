import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/app_bar_widget.dart';
import 'package:zero/core/widgets/circular_progress_widget.dart';
import 'package:zero/modules/home/services/device_service.dart';

class ForensicResultsScreen extends StatefulWidget {
  ForensicResultsScreen(this.device);

  final Device device;

  @override
  _ForensicResultsScreenState createState() =>
      _ForensicResultsScreenState(this.device);
}

class _ForensicResultsScreenState extends State<ForensicResultsScreen> {
  _ForensicResultsScreenState(this.device);

  // Key form state
  final GlobalKey<FormState> modulesResultsFormKey = new GlobalKey<FormState>();

  // Device to load results
  final Device device;

  // Selected value in dropdown modules
  String selectedModule;

  // Selected value in dropdown results
  String selectedResultId;

  // List of forensic results
  List<String> modulesResults;

  // List of forensic results id
  List<String> modulesResultsId;

  // Text result from search module
  String resultModule;

  // Boolean to define if load is pressed
  bool loadPressed = false;

  @override
  void initState() {
    super.initState();
    // Get modules results
    modulesResults = device.getModulesExecuted();
    // Set selected module
    this.selectedModule = this.modulesResults.first;
  }

  Widget buildBody() {
    return new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this.modulesResultsFormKey,
          child: new ListView(
            children: <Widget>[
              getDropDownModules(), // Dropdown modules
              getDropDownResults(), // Dropdown modules result
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getLoadButton(), // Load button
                  Padding(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  getClearButton() // Clear button
                ],
              ),
              getContainerResult()
            ],
          ),
        ));
  }

  // Get dropdown of modules executed
  DropdownButtonFormField<String> getDropDownModules() {
    // Return the dropdownbutton
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItems(this.modulesResults),
      onChanged: (String newValue) {
        setState(() {
          this.selectedModule = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_forensic_results_label_modules')),
      value: this.selectedModule,
    );
  }

  // Get dropdown of execution modules
  DropdownButtonFormField<String> getDropDownResults() {
    List<String> resultsSelected = device.getResultModule(this.selectedModule);
    // Pass list result to map with dates
    Map results = getMapDate(resultsSelected);

    // Set selected module
    this.selectedResultId = this.selectedResultId == null
        ? resultsSelected.first
        : this.selectedResultId;

    // Return the dropdownbutton
    return DropdownButtonFormField<String>(
      items: CoreUtils.getDropdownMenuItemsFromMap(results),
      onChanged: (String newValue) {
        setState(() {
          this.selectedResultId = newValue;
        });
      },
      decoration: new InputDecoration(
          labelText: LocalizationsService.of(context)
              .trans('screen_forensic_results_label_executed')),
      value: this.selectedResultId,
    );
  }

  // Pass list with timestamp to map with timestamp, date
  Map getMapDate(List resultsSelected) {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    Map<String, String> result = new Map<String, String>();

    for (String item in resultsSelected) {
      int resultMiliseconds =
          double.tryParse(item).round() ?? int.tryParse(item);
      result[item] = formatter.format(
          new DateTime.fromMillisecondsSinceEpoch(resultMiliseconds * 1000));
    }
    return result;
  }

  // Return load button
  Container getLoadButton() {
    return Container(
      child: new RaisedButton(
        child: new Text(
          LocalizationsService.of(context)
              .trans('screen_forensic_results_button_search'),
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          setState(() {
            // Reload state
            loadPressed = true;
          });
        },
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  // Return clear button
  Container getClearButton() {
    return Container(
      child: new RaisedButton(
        child: new Text(
          LocalizationsService.of(context)
              .trans('screen_forensic_results_button_clear'),
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: !this.loadPressed
            ? null
            : () {
                setState(() {
                  // Init variables
                  this.selectedModule = this.modulesResults.first;
                  this.selectedResultId = null;
                  this.resultModule = null;
                  loadPressed = false;
                });
              },
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  // Return run button
  Container getContainerResult() {
    if(!loadPressed) {
      return Container();
    } else {
      return new Container(
          child: FutureBuilder<String>(
            future: getModuleResult(this.selectedResultId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                this.resultModule = snapshot.data;
                // Return container
                return Container(
                  color: Theme.of(context).cardColor,
                  child: new Padding(
                      padding: new EdgeInsets.all(10.0), child: new Text(resultModule)),
                );

              }

              // Show a loading spinner
              return Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgress(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                          LocalizationsService.of(context)
                              .trans('screen_forensic_results_loading_results'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0)),
                    )
                  ],
                ),
              );
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTextWidget(context, 'screen_title_forensic_results'),
        body: buildBody());
  }
}
