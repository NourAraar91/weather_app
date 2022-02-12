import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';

class WeatherScreenBloc extends Cubit<WeatherBlocState> {
  final WeatherDataSource dataSource;
  final City city;

  WeatherScreenBloc({
    required this.dataSource,
    required this.city,
  }) : super(WeatherBlocInitialState());

  void featchWeather() {
    emit(LoadingState());
    emit(WeatherLoadedState());
  }
}

abstract class WeatherBlocState {}

class WeatherBlocInitialState implements WeatherBlocState {}

class LoadingState implements WeatherBlocState {}

class WeatherLoadedState implements WeatherBlocState {}