import 'package:weather_app/api/api_client.dart';

abstract class WeatherDataSource {}

class WeatherDataSourceImpl implements WeatherDataSource {
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});

  getWeatherByLatAndLng(double lat, double lon) {
    apiClient.getWeatherByLatAndLng(lat, lon);
  }
}
