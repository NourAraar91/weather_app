import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/models/weather.dart';
import 'package:dio/dio.dart';

import 'weather_data_source_test.dart';

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  late WeatherScreenBloc weatherScreenBloc;
  late ForecastWeatherScreenBloc forecastWeatherScreenBloc;

  City _kualaLumpur =
      const City(lat: 3.1478, lon: 101.6953, name: "Kuala Lumpur");

  CurrentWeather _currentWeather = MockDataProvider.currentWeatherFixture();

  ForcastResult _forcastResult = MockDataProvider.currentForecastFixture();

  setUp(() async {
    apiClient = MockAPIClient();
    dataSource = WeatherDataSourceImpl(apiClient: apiClient);

    weatherScreenBloc = WeatherScreenBloc(
      dataSource: dataSource,
      city: _kualaLumpur,
    );

    forecastWeatherScreenBloc = ForecastWeatherScreenBloc(
      dataSource: dataSource,
      city: _kualaLumpur,
    );
  });

  tearDown(() {
    forecastWeatherScreenBloc.close();
    weatherScreenBloc.close();
  });

  group('weather test', () {
    test('bloc should have city with lat and lon', () {
      expect(weatherScreenBloc.city.lat, _kualaLumpur.lat);
      expect(weatherScreenBloc.city.lon, _kualaLumpur.lon);
    });

    test('should have initial state as [WeatherBlocInitialState]', () {
      expect(weatherScreenBloc.state.runtimeType, WeatherBlocInitialState);
    });

    blocTest(
      'should have [LoadingWeatherState, WeatherLoadedState] when call featchWeather',
      build: () => weatherScreenBloc,
      act: (WeatherScreenBloc bloc) {
        when(() => apiClient.getWeatherByLatAndLng(
                _kualaLumpur.lat, _kualaLumpur.lon))
            .thenAnswer((_) async => _currentWeather);
        bloc.featchWeather();
      },
      expect: () => [
        isA<LoadingWeatherState>(),
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
        LoadingWeatherState(),
        WeatherLoadedState(currentWeather: _currentWeather),
      ],
    );

    blocTest(
      'should have a [WeatherFailureState] response when featchWeather return 404',
      build: () => weatherScreenBloc,
      act: (WeatherScreenBloc bloc) {
        when(() => apiClient.getWeatherByLatAndLng(
            _kualaLumpur.lat, _kualaLumpur.lon)).thenThrow(
          DioError(
            response: Response(
              data: 'Something went wrong',
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );
        bloc.featchWeather();
      },
      expect: () => [
        LoadingWeatherState(),
        WeatherFailureState(),
      ],
    );
  });

  group('forecast test', () {
    blocTest(
      'should have [LoadingForecastState, ForecastWeatherLoadedState] when call featchForecastWeather',
      build: () => forecastWeatherScreenBloc,
      act: (ForecastWeatherScreenBloc bloc) {
        when(() => apiClient.getForecastWeatherByLatAndLng(
                _kualaLumpur.lat, _kualaLumpur.lon))
            .thenAnswer((_) async => _forcastResult);
        bloc.featchForecastWeather();
      },
      expect: () => [
        isA<LoadingForecastState>(),
        isA<ForecastWeatherLoadedState>(),
      ],
    );
    blocTest(
      'should have a weather response when featchWeather return',
      build: () => forecastWeatherScreenBloc,
      act: (ForecastWeatherScreenBloc bloc) {
        when(() => apiClient.getForecastWeatherByLatAndLng(
                _kualaLumpur.lat, _kualaLumpur.lon))
            .thenAnswer((_) async => _forcastResult);
        bloc.featchForecastWeather();
      },
      expect: () => [
        LoadingForecastState(),
        ForecastWeatherLoadedState(forcastResult: _forcastResult),
      ],
    );

    blocTest(
      'should have a [LoadingForecastState, ForecastWeatherFailureState] response when featchForecastWeather return 404',
      build: () => forecastWeatherScreenBloc,
      act: (ForecastWeatherScreenBloc bloc) {
        when(() => apiClient.getForecastWeatherByLatAndLng(
            _kualaLumpur.lat, _kualaLumpur.lon)).thenThrow(
          DioError(
            response: Response(
              data: 'Something went wrong',
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );
        bloc.featchForecastWeather();
      },
      expect: () => [
        LoadingForecastState(),
        ForecastWeatherFailureState(),
      ],
    );
  });
}
