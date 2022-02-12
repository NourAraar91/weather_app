import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';

class WeatherScreenBloc {
  final WeatherDataSource dataSource;
  final City city;
  
  WeatherScreenBloc({
    required this.dataSource,
    required this.city,
  });
}
