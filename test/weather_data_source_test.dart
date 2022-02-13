import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/forecast_result.dart';
import 'package:weather_app/models/weather.dart';
import 'package:dio/dio.dart';

class MockAPIClient extends Mock implements APIClient {}

class MockDataProvider {
  static CurrentWeather currentWeatherFixture() {
    return CurrentWeather(
        name: "Kuala Lumpur",
        dt: 16433020,
        weather: [],
        main: MainClass(
          temp: 30,
          tempMax: 32,
          tempMin: 28,
        ));
  }

  static ForcastResult currentForecastFixture() {
    return ForcastResult(
        list: [],
        city: Place(
          coord: Coord(lat: 2.4, lon: 110.1),
          name: "Kuala Lumpur",
        ));
  }
}

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  CurrentWeather _mockWeather = MockDataProvider.currentWeatherFixture();
  ForcastResult _mockForecastResult = MockDataProvider.currentForecastFixture();

  setUp(() async {
    registerFallbackValue(Uri());

    apiClient = MockAPIClient();

    dataSource = WeatherDataSourceImpl(apiClient: apiClient);
  });
  group(
    'get /weather',
    () {
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

      test(
        'should throw an Exception when the response code is 404 or other (unsuccess)',
        () async {
          // arrange
          when(() => apiClient.getWeatherByLatAndLng(3.14, 101.69)).thenThrow(
            DioError(
              response: Response(
                data: 'Something went wrong',
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ),
              requestOptions: RequestOptions(path: ''),
            ),
          );
          // act
          final call = dataSource.getWeatherByLatAndLng;
          // assert
          expect(
            () => call(3.14, 101.69),
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );

  group(
    'get /forecast',
    () {
      test(
        'should perform a GET request on /forecast?lat=3.14&lon=101.69',
        () async {
          // arrange
          when(
            () => apiClient.getForecastWeatherByLatAndLng(3.14, 101.69),
          ).thenAnswer(
            (_) async => _mockForecastResult,
          );

          // act
          dataSource.getForecastWeatherByLatAndLng(3.14, 101.69);
          // assert
          verify(() => apiClient.getForecastWeatherByLatAndLng(3.14, 101.69));
          verifyNoMoreInteractions(apiClient);
        },
      );

      test(
        'should return ForecastResult() when get response /forecast?lat=3.14&lon=101.69',
        () async {
          when(
            () => apiClient.getForecastWeatherByLatAndLng(3.14, 101.69),
          ).thenAnswer(
            (_) async => _mockForecastResult,
          );

          final response =
              await dataSource.getForecastWeatherByLatAndLng(3.14, 101.69);

          expect(response, _mockForecastResult);
        },
      );

      test(
        'should throw an Exception when the response code is 404 or other (unsuccess)',
        () async {
          // arrange
          when(() => apiClient.getForecastWeatherByLatAndLng(3.14, 101.69))
              .thenThrow(
            DioError(
              response: Response(
                data: 'Something went wrong',
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ),
              requestOptions: RequestOptions(path: ''),
            ),
          );
          // act
          final call = dataSource.getForecastWeatherByLatAndLng;
          // assert
          expect(
            () => call(3.14, 101.69),
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );
}
