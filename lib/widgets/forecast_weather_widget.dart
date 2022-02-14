import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/tempruter_text.dart';
import 'package:weather_app/extensions/extensions.dart';

class ForecastWeatherWidget extends StatelessWidget {
  const ForecastWeatherWidget({Key? key, required this.element})
      : super(key: key);

  final CurrentWeather element;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(
                  'http://openweathermap.org/img/wn/${element.weather[0].icon}.png'),
            ),
            TempretureText(
              tempreture: element.main.temp!.floor(),
              style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 44, 44, 44),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              element.dt.formatedDate('EEE,d'),
              style: const TextStyle(
                  color: Color.fromARGB(255, 44, 44, 44),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
