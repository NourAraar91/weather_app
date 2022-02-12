import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';

import 'weather_data_source_test.dart';

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  late WeatherScreenBloc weatherScreenBloc;

  City _kualaLumpur = City(lat: 3.1478, lon: 101.6953);

  CurrentWeather _currentWeather = CurrentWeather();

  setUp(() async {
    apiClient = MockAPIClient();
    dataSource = WeatherDataSourceImpl(apiClient: apiClient);

    weatherScreenBloc = WeatherScreenBloc(
      dataSource: dataSource,
      city: _kualaLumpur,
    );
  });

  test('bloc should have city with lat and lon', () {
    expect(weatherScreenBloc.city.lat, _kualaLumpur.lat);
    expect(weatherScreenBloc.city.lon, _kualaLumpur.lon);
  });

  test('should have initial state as [WeatherBlocInitialState]', () {
    expect(weatherScreenBloc.state.runtimeType, WeatherBlocInitialState);
  });

  blocTest(
    'should have [LoadingState, WeatherLoadedState] when call featchWeather',
    build: () => weatherScreenBloc,
    act: (WeatherScreenBloc bloc) {
      when(() => apiClient.getWeatherByLatAndLng(
              _kualaLumpur.lat, _kualaLumpur.lon))
          .thenAnswer((_) async => _currentWeather);
      bloc.featchWeather();
    },
    expect: () => [
      isA<LoadingState>(),
      isA<WeatherLoadedState>(),
    ],
  );
  blocTest(
    'should have a weather response when featchWeather return',
    build: () => weatherScreenBloc,
    act: (WeatherScreenBloc bloc) {
      when(() => apiClient.getWeatherByLatAndLng(
              _kualaLumpur.lat, _kualaLumpur.lon))
          .thenAnswer((_) async => _currentWeather);
      bloc.featchWeather();
    },
    expect: () => [
      LoadingState(),
      WeatherLoadedState(currentWeather: _currentWeather),
    ],
  );
}
