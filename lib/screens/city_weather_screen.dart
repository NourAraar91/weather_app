import 'package:flutter/material.dart';
import 'package:weather_app/widgets/city_weather_widget.dart';
import 'package:weather_app/widgets/forecast_weather_section_widget.dart';

class CityWeatherScreen extends StatefulWidget {
  const CityWeatherScreen({Key? key}) : super(key: key);

  @override
  State<CityWeatherScreen> createState() => _CityWeatherScreenState();
}

class _CityWeatherScreenState extends State<CityWeatherScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.menu))
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(children: const [
        Expanded(child: CityWeatherWidget()),
        Expanded(child: ForecastWeatherSectionWidget()),
      ]),
    );
  }
}
