import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'weather.g.dart';

@JsonSerializable()
class CurrentWeather {
  CurrentWeather({
    required this.weather,
    required this.main,
    required this.dt,
    required this.id,
    required this.name,
  });

  List<Weather> weather;
  MainClass main;
  int dt;
  int id;
  String name;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);
}

@JsonSerializable()
class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
    this.condition,
  });

  final int? id;
  final String? main;
  final String? description;
  final String? icon;
  final WeatherCondition? condition;

  AssetImage get image {
    return condition?.image ?? const AssetImage('assets/images/800.png');
  }

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  static WeatherCondition _mapStringToWeatherCondition(int id) {
    WeatherCondition state;
    switch (id) {
      case 200:
      case 201:
      case 202:
      case 210:
      case 211:
      case 212:
      case 221:
      case 230:
      case 231:
      case 232:
        state = WeatherCondition.thunderstorm;
        break;
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        state = WeatherCondition.drizzle;
        break;
      case 502:
      case 503:
        state = WeatherCondition.heavyRain;
        break;
      case 500:
      case 501:
      case 511:
      case 520:
        state = WeatherCondition.lightRain;
        break;
      case 521:
      case 522:
      case 531:
        state = WeatherCondition.showers;
        break;
      case 504:
        state = WeatherCondition.hail;
        break;
      case 600:
      case 601:
      case 602:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        state = WeatherCondition.snow;
        break;
      case 611:
        state = WeatherCondition.sleet;
        break;
      case 803:
      case 804:
        state = WeatherCondition.heavyCloud;
        break;
      case 801:
      case 802:
        state = WeatherCondition.lightCloud;
        break;
      case 800:
        state = WeatherCondition.clear;
        break;
      default:
        state = WeatherCondition.unknown;
    }
    return state;
  }
}

enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  drizzle,
  unknown
}

extension on WeatherCondition {
  AssetImage get image {
    switch (this) {
      case WeatherCondition.clear:
        return const AssetImage('assets/images/800.png');
      case WeatherCondition.snow:
        return const AssetImage('assets/images/600.png');
      case WeatherCondition.sleet:
        return const AssetImage('assets/im´ages/611.png');
      case WeatherCondition.hail:
        return const AssetImage('assets/images/504.png');
      case WeatherCondition.thunderstorm:
        return const AssetImage('assets/images/200.png');
      case WeatherCondition.heavyRain:
        return const AssetImage('assets/images/502.png');
      case WeatherCondition.lightRain:
        return const AssetImage('assets/images/500.png');
      case WeatherCondition.showers:
        return const AssetImage('assets/images/521.png');
      case WeatherCondition.heavyCloud:
        return const AssetImage('assets/images/803.png');
      case WeatherCondition.lightCloud:
        return const AssetImage('assets/images/801.png');
      case WeatherCondition.drizzle:
        return const AssetImage('assets/images/611.png');
      case WeatherCondition.unknown:
        return const AssetImage('assets/images/800.png');
      default:
        return const AssetImage('assets/images/800.png');
    }
  }
}

@JsonSerializable()
class MainClass {
  MainClass({
    this.temp,
    this.tempMin,
    this.tempMax,
  });

  double? temp;
  @JsonKey(name: 'temp_min')
  double? tempMin;
  @JsonKey(name: 'temp_max')
  double? tempMax;

  factory MainClass.fromJson(Map<String, dynamic> json) =>
      _$MainClassFromJson(json);
  Map<String, dynamic> toJson() => _$MainClassToJson(this);
}
