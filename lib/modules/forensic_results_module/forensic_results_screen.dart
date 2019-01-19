import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/services/localizations_service.dart';
import 'package:zero/core/utils/utils.dart';
import 'package:zero/core/widgets/app_bar_widget.dart';
import 'package:zero/modules/home/services/device_service.dart';

class ForensicResultsScreen extends StatefulWidget {
  ForensicResultsScreen(this.device);

  final Device device;

  @override
  _ForensicResultsScreenState createState() => _ForensicResultsScreenState(this.device);
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
            children: <Widget>[getDropDownModules(), getDropDownResults(), getRunButton(), getContainerResult()],
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
    this.selectedResultId = resultsSelected.first;

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
    
    for(String item in resultsSelected) {
      int resultMiliseconds = double.tryParse(item).round() ?? int.tryParse(item);
      result[item] = formatter.format(new DateTime.fromMillisecondsSinceEpoch(resultMiliseconds*1000));
    }
      return result;
  }

  // Return load button
  Container getRunButton() {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: new RaisedButton(
        child: new Text(
          LocalizationsService.of(context)
              .trans('screen_forensic_results_button_search'),
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          // Get the result
          String result = await getModuleResult(this.selectedResultId);

          setState(() {
            // Set the result
            resultModule = result;
          });
        },
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
    );
  }

  // Return run button
  Container getContainerResult() {
    if(this.resultModule == null || this.resultModule.isNotEmpty) {
      return Container();
    } else {
      return Container(
        child: new Text(resultModule),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTextWidget(context, 'screen_title_forensic_results'),
        body: buildBody()
    );
  }
}
