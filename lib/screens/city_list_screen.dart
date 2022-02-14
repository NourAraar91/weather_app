import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/city_list_data_source.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/screens/city_selection_screen.dart';
import 'package:weather_app/screens/city_weather_screen.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/tempruter_text.dart';
import 'package:dio/dio.dart';

abstract class CityListScreenState {}

class CityListScreenInitialState extends CityListScreenState {}

class CityListScreenLoadingState extends CityListScreenState {}

class CityListScreenLoadedState extends CityListScreenState {
  final List<City> cities;

  CityListScreenLoadedState({required this.cities});
}

class CityListScreenBloc extends Cubit<CityListScreenState> {
  CityListDataSource cityListDataSource = CityListDataSourceImpl();

  CityListScreenBloc() : super(CityListScreenInitialState());

  featchSelectedCities() {
    var cities = cityListDataSource.featchSelectedCities();
    final cachedCurrentCity = cityListDataSource.getCurrentCityCache();
    if (cachedCurrentCity != null) {
      cities.insert(0, cachedCurrentCity);
    }
    emit(CityListScreenLoadedState(cities: cities));
  }

  List<City> featchCities() {
    return cityListDataSource.featchCities();
  }

  void selecteCity(City city) {
    cityListDataSource.selectCity(city);
    emit(CityListScreenLoadedState(
        cities: cityListDataSource.featchSelectedCities()));
  }

  Future<void> fetchUserCurrentCity() async {
    emit(CityListScreenLoadingState());
    final currentLocation = await LocationService.getCurrentLocation();
    var city = City(
        lat: currentLocation.latitude,
        lon: currentLocation.longitude,
        name: "Current Location");
    cityListDataSource.setCurrentCityCache(city);
    featchSelectedCities();
  }
}

class CityListScreen extends StatefulWidget {
  final WeatherDataSource dataSource;
  const CityListScreen({Key? key, required this.dataSource}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  late CityListScreenBloc _bloc;

  @override
  void initState() {
    _bloc = CityListScreenBloc();
    setUp();
    super.initState();
  }

  setUp() async {
    await _bloc.fetchUserCurrentCity();
    _bloc.featchSelectedCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push<City>(context,
                      MaterialPageRoute(builder: (context) {
                    return CitySelectionScreen(
                      items: _bloc.featchCities(),
                      onSelectItem: (index, city) {
                        Navigator.pop(context);
                        _bloc.selecteCity(city);
                        _bloc.featchSelectedCities();
                      },
                    );
                  }));
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ))
          ],
        ),
        body: BlocBuilder<CityListScreenBloc, CityListScreenState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is CityListScreenLoadedState) {
              return RefreshIndicator(
                onRefresh: () async {
                  setUp();
                  return;
                },
                child: ListView.builder(
                    itemCount: state.cities.length,
                    itemBuilder: (context, index) {
                      return CityWeatherWidget(
                        weatherScreenBloc: WeatherScreenBloc(
                            city: state.cities[index],
                            dataSource: widget.dataSource),
                      );
                    }),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class CityWeatherWidget extends StatefulWidget {
  final WeatherScreenBloc weatherScreenBloc;
  const CityWeatherWidget({
    Key? key,
    required this.weatherScreenBloc,
  }) : super(key: key);

  @override
  State<CityWeatherWidget> createState() => _CityWeatherWidgetState();
}

class _CityWeatherWidgetState extends State<CityWeatherWidget> {
  @override
  void didChangeDependencies() {
    widget.weatherScreenBloc.featchWeather();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<WeatherScreenBloc>(
                create: (BuildContext context) => widget.weatherScreenBloc,
              ),
              BlocProvider<ForecastWeatherScreenBloc>(
                  create: (BuildContext context) => ForecastWeatherScreenBloc(
                        dataSource:
                            WeatherDataSourceImpl(apiClient: APIClient(Dio())),
                        city: widget.weatherScreenBloc.city,
                      )),
            ],
            child: const CityWeatherScreen(),
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 150,
        child: BlocBuilder<WeatherScreenBloc, WeatherBlocState>(
            bloc: widget.weatherScreenBloc,
            builder: (context, state) {
              if (state is WeatherLoadedState) {
                return Container(
                  height: 150,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: state.img, fit: BoxFit.fill),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  state.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            TempretureText(
                              tempreture: state.temp,
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "H:${state.tempMax}  L:${state.tempMin}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ]),
                );
              }
              if (state is WeatherFailureState) {
                return CustomErrorWidget(
                    errorMessage: "Something went wrong",
                    onRetryPressed: () {
                      widget.weatherScreenBloc.featchWeather();
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
