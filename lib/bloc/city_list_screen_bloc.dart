import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/dataSource/city_list_data_source.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/services/location_service.dart';

class CityListScreenCubit extends Cubit<CityListScreenState> {
  CityListDataSource cityListDataSource = CityListDataSourceImpl();

  CityListScreenCubit() : super(CityListScreenInitialState());

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
    try {
      final currentLocation = await LocationService.getCurrentLocation();
      var city = City(
          lat: currentLocation.latitude,
          lon: currentLocation.longitude,
          name: "Current Location");
      cityListDataSource.setCurrentCityCache(city);
      featchSelectedCities();
    } catch (_) {
      emit(CityListScreenInitialState());
    }
  }
}

abstract class CityListScreenState {}

class CityListScreenInitialState extends CityListScreenState {}

class CityListScreenLoadingState extends CityListScreenState {}

class CityListScreenLoadedState extends CityListScreenState {
  final List<City> cities;

  CityListScreenLoadedState({required this.cities});
}
