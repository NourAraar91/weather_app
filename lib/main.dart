import 'package:flutter/material.dart';
import 'package:weather_app/dataStore/data_store.dart';
import 'package:weather_app/screens/city_select_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataStore.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CityListScreen(),
    );
  }
}
