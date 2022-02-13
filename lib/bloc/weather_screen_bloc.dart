import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/extensions/extensions.dart';

class WeatherScreenBloc extends Cubit<WeatherBlocState> {
  final WeatherDataSource dataSource;
  final City city;

  WeatherScreenBloc({
    required this.dataSource,
    required this.city,
  }) : super(WeatherBlocInitialState());

  void featchWeather() async {
    emit(LoadingWeatherState());
    try {
      final response =
          await dataSource.getWeatherByLatAndLng(city.lat, city.lon);
      emit(WeatherLoadedState(currentWeather: response));
    } on ServerException catch (_) {
      emit(WeatherFailureState());
    }
  }
}

abstract class WeatherBlocState extends Equatable {}

class WeatherBlocInitialState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class LoadingWeatherState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class WeatherLoadedState extends WeatherBlocState {
  final CurrentWeather currentWeather;
  WeatherLoadedState({required this.currentWeather});

  String get name => currentWeather.name;
  int get tempMax => currentWeather.main.tempMax!.toInt();
  int get tempMin => currentWeather.main.tempMin!.toInt();
  String get description => currentWeather.weather.first.description ?? '';
  int get temp => currentWeather.main.temp!.toInt();
  String get time => currentWeather.dt.formatedDate(DateFormat.HOUR_MINUTE);
  AssetImage get img => currentWeather.weather[0].image;

  @override
  List<Object?> get props => [currentWeather];
}

class WeatherFailureState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}
