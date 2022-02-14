// ForecastWeatherWidget
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/forecast_weather_widget.dart';

class ForecastWeatherSectionWidget extends StatefulWidget {
  const ForecastWeatherSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ForecastWeatherSectionWidget> createState() =>
      _ForecastWeatherSectionWidgetState();
}

class _ForecastWeatherSectionWidgetState
    extends State<ForecastWeatherSectionWidget> {
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
                return ForecastWeatherWidget(element: element);
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
