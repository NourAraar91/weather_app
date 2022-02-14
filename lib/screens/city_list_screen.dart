import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/bloc/city_list_screen_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_screen_bloc.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/screens/city_selection_screen.dart';
import 'package:weather_app/screens/city_weather_screen.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/tempruter_text.dart';
import 'package:dio/dio.dart';

class CityListScreen extends StatefulWidget {
  final WeatherDataSource dataSource;
  const CityListScreen({Key? key, required this.dataSource}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  late CityListScreenCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<CityListScreenCubit>();
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
        body: BlocBuilder<CityListScreenCubit, CityListScreenState>(
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
                      return BlocProvider(
                        create: ((context) => WeatherScreenCubit(
                            city: state.cities[index],
                            dataSource: widget.dataSource)),
                        child: const CityWeatherWidget(),
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
  const CityWeatherWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CityWeatherWidget> createState() => _CityWeatherWidgetState();
}

class _CityWeatherWidgetState extends State<CityWeatherWidget> {
  late WeatherScreenCubit weatherScreenBloc;

  @override
  void initState() {
    weatherScreenBloc = context.read<WeatherScreenCubit>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    weatherScreenBloc.featchWeather();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<WeatherScreenCubit>(
                create: (BuildContext context) => weatherScreenBloc,
              ),
              BlocProvider<ForecastWeatherScreenCubit>(
                  create: (BuildContext context) => ForecastWeatherScreenCubit(
                        dataSource:
                            WeatherDataSourceImpl(apiClient: APIClient(Dio())),
                        city: weatherScreenBloc.city,
                      )),
            ],
            child: const CityWeatherScreen(),
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 150,
        child: BlocBuilder<WeatherScreenCubit, WeatherBlocState>(
            bloc: weatherScreenBloc,
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
                      weatherScreenBloc.featchWeather();
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
