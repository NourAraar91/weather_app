import 'dart:convert';

import 'package:weather_app/dataStore/data_store.dart';
import 'package:weather_app/models/city.dart';

abstract class CityListDataSource {
  List<City> featchCities();
  List<City> featchSelectedCities();
  saveSelectedCities(List<City> cityList);
  selectCity(City city);
  City? getCurrentCityCache();
  setCurrentCityCache(City city);
}

class CityListDataSourceImpl implements CityListDataSource {
  late DataStore dataStore;

  CityListDataSourceImpl() {
    dataStore = DataStore();
  }

  @override
  List<City> featchCities() {
    return cities.map((e) => City.fromJson(e)).toList();
  }

  @override
  List<City> featchSelectedCities() {
    var cityData = dataStore.read('selected_cities');
    if (cityData != null) {
      try {
        var cityList =
            List<City>.from(json.decode(cityData).map((x) => City.fromJson(x)));
        return cityList;
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  saveSelectedCities(List<City> _selectedCities) {
    dataStore.save(
        'selected_cities',
        json.encode(
            List<dynamic>.from(_selectedCities.map((x) => x.toJson()))));
  }

  @override
  City? getCurrentCityCache() {
    var currentCityData = dataStore.read('current_city');
    if (currentCityData != null) {
      return City.fromJson(json.decode(currentCityData));
    }
    return null;
  }

  @override
  setCurrentCityCache(City city) {
    dataStore.prefs.setString("current_city", json.encode(city.toJson()));
  }

  @override
  void selectCity(City city) {
    var _selectedCities = featchSelectedCities();
    if (!_selectedCities.contains(city)) {
      _selectedCities.add(city);
    }
    saveSelectedCities(_selectedCities);
  }
}

List<Map<String, Object>> cities = [
  {"city": "Kuala Lumpur", "lat": 3.1478, "lng": 101.6953},
  {"city": "Klang", "lat": 3.0333, "lng": 101.4500},
  {"city": "Ipoh", "lat": 4.6000, "lng": 101.0700},
  {"city": "Butterworth", "lat": 5.3942, "lng": 100.3664},
  {"city": "Johor Bahru", "lat": 1.4556, "lng": 103.7611},
  {"city": "George Town", "lat": 5.4145, "lng": 100.3292},
  {"city": "Petaling Jaya", "lat": 3.1073, "lng": 101.6067},
  {"city": "Kuantan", "lat": 3.8167, "lng": 103.3333},
  {"city": "Shah Alam", "lat": 3.0833, "lng": 101.5333},
  {"city": "Kota Bharu", "lat": 6.1333, "lng": 102.2500},
  {"city": "Melaka", "lat": 2.1889, "lng": 102.2511},
  {"city": "Kota Kinabalu", "lat": 5.9750, "lng": 116.0725},
  {"city": "Seremban", "lat": 2.7297, "lng": 101.9381},
  {"city": "Sandakan", "lat": 5.8388, "lng": 118.1173},
  {"city": "Sungai Petani", "lat": 5.6500, "lng": 100.4800},
  {"city": "Kuching", "lat": 1.5397, "lng": 110.3542},
  {"city": "Kuala Terengganu", "lat": 5.3303, "lng": 103.1408},
  {"city": "Alor Setar", "lat": 6.1167, "lng": 100.3667},
  {"city": "Putrajaya", "lat": 2.9300, "lng": 101.6900},
  {"city": "Kangar", "lat": 6.4414, "lng": 100.1986},
  {"city": "Labuan", "lat": 5.2803, "lng": 115.2475},
  {"city": "Pasir Mas", "lat": 6.0493, "lng": 102.1399},
  {"city": "Tumpat", "lat": 6.2000, "lng": 102.1667},
  {"city": "Ketereh", "lat": 5.9570, "lng": 102.2482},
  {"city": "Kampung Lemal", "lat": 6.0302, "lng": 102.1413},
  {"city": "Pulai Chondong", "lat": 5.8713, "lng": 102.2318}
];
