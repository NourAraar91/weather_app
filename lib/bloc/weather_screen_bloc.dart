import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/api/api_client.dart';
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

  void featchForecastWeather() async {
    emit(LoadingForecastState());
    try {
      final response =
          await dataSource.getForecastWeatherByLatAndLng(city.lat, city.lon);
      emit(ForecastWeatherLoadedState(forcastResult: response));
    } on ServerException catch (_) {
      emit(ForecastWeatherFailureState());
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

  @override
  List<Object?> get props => [currentWeather];
}

class WeatherFailureState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class LoadingForecastState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}

class ForecastWeatherLoadedState extends WeatherBlocState {
  final ForcastResult forcastResult;
  ForecastWeatherLoadedState({required this.forcastResult});

  @override
  List<Object?> get props => [forcastResult];
}

class ForecastWeatherFailureState extends WeatherBlocState {
  @override
  List<Object?> get props => [];
}
