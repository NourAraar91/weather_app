

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';

class MockAPIClient extends Mock implements APIClient {}

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  setUp(() async {
    registerFallbackValue(Uri());

    apiClient = MockAPIClient();

    dataSource = WeatherDataSourceImpl(apiClient: apiClient);
  });

}