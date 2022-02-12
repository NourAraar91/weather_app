import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/weather.dart';

class MockAPIClient extends Mock implements APIClient {}

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  CurrentWeather _mockWeather = CurrentWeather();

  setUp(() async {
    registerFallbackValue(Uri());

    apiClient = MockAPIClient();

    dataSource = WeatherDataSourceImpl(apiClient: apiClient);
  });

  test(
    'should perform a GET request on /weather?lat=3.14&lon=101.69',
    () async {
      // arrange
      when(
        () => apiClient.getWeatherByLatAndLng(3.14, 101.69),
      ).thenAnswer(
        (_) async => _mockWeather,
      );

      // act
      dataSource.getWeatherByLatAndLng(3.14, 101.69);
      // assert
      verify(() => apiClient.getWeatherByLatAndLng(3.14, 101.69));
      verifyNoMoreInteractions(apiClient);
    },
  );
  test(
    'should return Weather() when get response /weather?lat=3.14&lon=101.69',
    () async {
      when(
        () => apiClient.getWeatherByLatAndLng(3.14, 101.69),
      ).thenAnswer(
        (_) async => _mockWeather,
      );

      final response = await dataSource.getWeatherByLatAndLng(3.14, 101.69);

      expect(response, _mockWeather);
    },
  );
}