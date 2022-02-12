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

  City _kualaLumpur = City();

  setUp(() async {
    apiClient = MockAPIClient();
    dataSource = WeatherDataSourceImpl(apiClient: apiClient);

    weatherScreenBloc = WeatherScreenBloc(
      dataSource: dataSource,
      city: _kualaLumpur,
    );
  });
}
