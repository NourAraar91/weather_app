import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/models/weather.dart';
import 'package:dio/dio.dart';

abstract class WeatherDataSource {
  Future<CurrentWeather> getWeatherByLatAndLng(double lat, double lon);

  Future<ForecastResult> getForecastWeatherByLatAndLng(double lat, double lon);
  late Map<String, CurrentWeather> weatherCache;
  late Map<String, ForecastResult> forecastCache;
}

class WeatherDataSourceImpl implements WeatherDataSource {
  @override
  Map<String, CurrentWeather> weatherCache = {};
  @override
  Map<String, ForecastResult> forecastCache = {};
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});

  @override
  Future<CurrentWeather> getWeatherByLatAndLng(double lat, double lon) async {
    try {
      final response = await apiClient.getWeatherByLatAndLng(lat, lon);
      weatherCache[response.name!] = response;
      return response;
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<ForecastResult> getForecastWeatherByLatAndLng(
      double lat, double lon) async {
    try {
      final response = await apiClient.getForecastWeatherByLatAndLng(lat, lon);
      forecastCache[response.city.name] = response;
      return response;
    } on DioError catch (_) {
      throw ServerException();
    }
  }
}
