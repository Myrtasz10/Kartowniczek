import 'package:flutter/material.dart';
import 'package:kartowniczek/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TysiacSettings extends StatefulWidget {
  const TysiacSettings({Key? key}) : super(key: key);

  @override
  _TysiacSettings createState() => _TysiacSettings();
}

class _TysiacSettings extends State<TysiacSettings> {
  AppSettings settings = AppSettings();

  @override
  void initState() {
    //TODO: default
    readBool('autoDelete');
    if (settings.autoDelete == null) {
      settings.autoDelete = false;
      readBool('autoDelete');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
      ),
      body: SwitchListTile(
        title: const Text(
            'Po zakończeniu rozgrywki automatycznie usuwaj skojarzone z nią zapisy'),
          value: settings.autoDelete,
          onChanged: (newVal) {
            setState(() {
              settings.autoDelete = newVal;
              writeBool('autoDelete', newVal);
            });
          },
        secondary: const Icon(Icons.delete),
      ),
    );
  }

  void readBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (key == 'autoDelete') {
        settings.autoDelete = prefs.getBool(key) ?? false;
      }
    });
  }

  void writeBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

class AppSettings {
  bool autoDelete;

  AppSettings({this.autoDelete = false});
}
