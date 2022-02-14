// CityWeatherWidget
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/widgets/tempruter_text.dart';

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
    context.read<WeatherScreenCubit>().featchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherScreenCubit, WeatherBlocState>(
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
