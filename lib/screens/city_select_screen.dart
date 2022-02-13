import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/bloc/weather_screen_bloc.dart';
import 'package:weather_app/dataSource/city_list_data_source.dart';
import 'package:weather_app/dataSource/weather_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/tempruter_text.dart';
import 'package:dio/dio.dart';

abstract class CityListScreenState extends Equatable {}

class CityListScreenInitialState extends CityListScreenState {
  @override
  List<Object?> get props => [];
}

class CityListScreenLoadedState extends CityListScreenState {
  final List<City> cities;

  CityListScreenLoadedState({required this.cities});

  @override
  List<Object?> get props => [];
}

class CityListScreenBloc extends Cubit<CityListScreenState> {
  CityListDataSource cityListDataSource = CityListDataSourceImpl();

  CityListScreenBloc() : super(CityListScreenInitialState());

  featchCityList() {
    final cities = cityListDataSource.featchCities();
    emit(CityListScreenLoadedState(cities: cities));
  }
}

class CityListScreen extends StatefulWidget {
  const CityListScreen({Key? key}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final CityListScreenBloc _bloc = CityListScreenBloc();

  @override
  void initState() {
    _bloc.featchCityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<CityListScreenBloc, CityListScreenState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is CityListScreenLoadedState) {
          return ListView.builder(
              itemCount: state.cities.length,
              itemBuilder: (context, index) {
                return CityWeatherWidget(
                  weatherScreenBloc: WeatherScreenBloc(
                      city: state.cities[index],
                      dataSource: WeatherDataSourceImpl(
                        apiClient: APIClient(
                          Dio(),
                        ),
                      )),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
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
    return Container(
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
    );
  }

  @override
  void dispose() {
    widget.weatherScreenBloc.close();
    super.dispose();
  }
}
