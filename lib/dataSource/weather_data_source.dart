import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/models/weather.dart';
import 'package:dio/dio.dart';

abstract class WeatherDataSource {}

class WeatherDataSourceImpl implements WeatherDataSource {
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});

  Future<CurrentWeather> getWeatherByLatAndLng(double lat, double lon) {
    try {
      return apiClient.getWeatherByLatAndLng(lat, lon);
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  Future<void> getForecastWeatherByLatAndLng(double lat, double lon) {
    return apiClient.getForecastWeatherByLatAndLng(lat, lon);
  }
}
