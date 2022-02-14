import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/forcast_weather_widget.dart';
import 'package:weather_app/widgets/tempruter_text.dart';

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
        Expanded(child: ForecastWeatherWidget()),
      ]),
    );
  }
}

// ForecastWeatherWidget
class ForecastWeatherWidget extends StatefulWidget {
  const ForecastWeatherWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ForecastWeatherWidget> createState() => _ForecastWeatherWidgetState();
}

class _ForecastWeatherWidgetState extends State<ForecastWeatherWidget> {
  @override
  void initState() {
    context.read<ForecastWeatherScreenBloc>().featchForecastWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastWeatherScreenBloc, ForecastWeatherBlocState>(
        builder: (context, state) {
      if (state is ForecastWeatherLoadedState) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // here we took every 8th element because
              // the forcast is for 5 days every 3 hours
              // so every 8th element is a new day
              children: getWeathersByDay(state.forcastResult.list)
                  .map((CurrentWeather element) {
                return ForcastWeatherWidget(element: element);
              }).toList()),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  List<CurrentWeather> getWeathersByDay(List<CurrentWeather> list) {
    List<CurrentWeather> temp = [];
    for (int i = 0; i < list.length; i += 8) {
      temp.add(list[i]);
    }
    return temp;
  }
}

// CityWeatherWidget
class CityWeatherWidget extends StatefulWidget {
  const CityWeatherWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CityWeatherWidget> createState() => _CityWeatherWidgetState();
}

class _CityWeatherWidgetState extends State<CityWeatherWidget> {
  @override
  void initState() {
    context.read<WeatherScreenBloc>().featchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherScreenBloc, WeatherBlocState>(
        builder: (context, state) {
      if (state is WeatherLoadedState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              state.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            TempretureText(
              tempreture: state.temp,
              style: const TextStyle(
                fontSize: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              state.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "H:${state.tempMax}\u00B0  L:${state.tempMin}\u00B0",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
