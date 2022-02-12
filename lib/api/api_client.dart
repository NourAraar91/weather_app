import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/constants/config.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'http://api.openweathermap.org/data/2.5')
abstract class APIClient {
  factory APIClient(Dio dio) = _APIClient;

  @GET("/weather")
  Future<void> getWeatherByLatAndLng(
    @Query("lat") double lat,
    @Query("lon") double lon, {
    @Query("units") String units = 'metrics',
    @Query("appid") String appid = Config.APP_ID,
  });
}
