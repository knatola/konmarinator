import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../util.dart';

class SettingsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsViewState();
  }
}

class SettingsViewState extends State<SettingsView> {
  int defaultNotificationTime = 0;
  DateTime selected;

  @override
  void initState() {
    super.initState();
    selected = DateTime.now();
  }

  String _dateTimeToHourString(DateTime date) {
    return date.hour.toString() + ':' + date.minute.toString();
  }

  void _openTimePicker() {
    DatePicker.showTimePicker(context, onConfirm: (date) {
      setState(() {
        selected = date;
      });
    });
  }

  Widget _buildNotificationSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: getGradient(context),
            borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, bottom: 8.0, top: 8, right: 8),
              child: Text(
                "Default notification time",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, bottom: 8.0, top: 8, right: 8),
              child: Text(
                _dateTimeToHourString(selected),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: _openTimePicker,
                  child: Text("Change",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: getGradient(context),
        ),
        child: ListView(
          children: <Widget>[_buildNotificationSelector()],
        ),
      ),
    );
  }
}
