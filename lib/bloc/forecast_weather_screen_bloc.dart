import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';

class ForecastWeatherScreenBloc extends Cubit<ForecastWeatherBlocState> {
  final WeatherDataSource dataSource;
  final City city;

  ForecastWeatherScreenBloc({
    required this.dataSource,
    required this.city,
  }) : super(ForecastWeatherBlocInitialState());

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

abstract class ForecastWeatherBlocState extends Equatable {}

class ForecastWeatherBlocInitialState extends ForecastWeatherBlocState {
  @override
  List<Object?> get props => [];
}


class LoadingForecastState extends ForecastWeatherBlocState {
  @override
  List<Object?> get props => [];
}

class ForecastWeatherLoadedState extends ForecastWeatherBlocState {
  final ForcastResult forcastResult;
  ForecastWeatherLoadedState({required this.forcastResult});

  @override
  List<Object?> get props => [forcastResult];
}

class ForecastWeatherFailureState extends ForecastWeatherBlocState {
  @override
  List<Object?> get props => [];
}
