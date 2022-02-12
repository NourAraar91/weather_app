import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/models/weather.dart';
import 'package:dio/dio.dart';

abstract class WeatherDataSource {
  Future<CurrentWeather> getWeatherByLatAndLng(double lat, double lon);

  Future<ForcastResult> getForecastWeatherByLatAndLng(double lat, double lon);
}

class WeatherDataSourceImpl implements WeatherDataSource {
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});

  @override
  Future<CurrentWeather> getWeatherByLatAndLng(double lat, double lon) {
    try {
      return apiClient.getWeatherByLatAndLng(lat, lon);
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<ForcastResult> getForecastWeatherByLatAndLng(double lat, double lon) {
    try {
      return apiClient.getForecastWeatherByLatAndLng(lat, lon);
    } on DioError catch (_) {
      throw ServerException();
    }
  }
}
