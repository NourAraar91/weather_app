import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';

class WeatherScreenBloc extends Cubit<WeatherBlocState> {
  final WeatherDataSource dataSource;
  final City city;

  WeatherScreenBloc({
    required this.dataSource,
    required this.city,
  }) : super(WeatherBlocInitialState());

  void featchWeather() {
    emit(LoadingState());
    dataSource.getWeatherByLatAndLng(city.lat, city.lon).then((response) {
      emit(WeatherLoadedState(currentWeather: response));
    });
  }
}

abstract class WeatherBlocState extends Equatable {}

class WeatherBlocInitialState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class WeatherLoadedState extends WeatherBlocState {
  final CurrentWeather currentWeather;
  WeatherLoadedState({required this.currentWeather});

  @override
  List<Object?> get props => [currentWeather];
}
