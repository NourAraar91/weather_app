import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/screens/city_select_screen.dart';
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const CityListScreen();
                }));
              },
              icon: const Icon(Icons.menu))
        ],
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
      return Container();
    });
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
      return Container();
    });
  }
}
