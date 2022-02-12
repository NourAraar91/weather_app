import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';

import 'weather_data_source_test.dart';

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockAPIClient apiClient;

  late WeatherScreenBloc weatherScreenBloc;

  City _kualaLumpur = City(lat: 3.1478, lon: 101.6953);

  setUp(() async {
    apiClient = MockAPIClient();
    dataSource = WeatherDataSourceImpl(apiClient: apiClient);

    weatherScreenBloc = WeatherScreenBloc(
      dataSource: dataSource,
      city: _kualaLumpur,
    );
  });

  test('test city coords', () {
    expect(weatherScreenBloc.city.lat, _kualaLumpur.lat);
    expect(weatherScreenBloc.city.lon, _kualaLumpur.lon);
  });
}
