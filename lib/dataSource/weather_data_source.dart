import 'package:weather_app/api/api_client.dart';

abstract class WeatherDataSource {}

class WeatherDataSourceImpl implements WeatherDataSource {
  final APIClient apiClient;

  WeatherDataSourceImpl({required this.apiClient});
}
