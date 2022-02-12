import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/models/weather.dart';

abstract class WeatherDataSource {}

class WeatherDataSourceImpl implements WeatherDataSource {
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});

  Future<Weather> getWeatherByLatAndLng(double lat, double lon) {
    return apiClient.getWeatherByLatAndLng(lat, lon);
  }
}
