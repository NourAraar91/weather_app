// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      main: MainClass.fromJson(json['main'] as Map<String, dynamic>),
      dt: json['dt'] as int,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'weather': instance.weather,
      'main': instance.main,
      'dt': instance.dt,
      'name': instance.name,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      main: json['main'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      condition:
          $enumDecodeNullable(_$WeatherConditionEnumMap, json['condition']),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
      'condition': _$WeatherConditionEnumMap[instance.condition],
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.snow: 'snow',
  WeatherCondition.sleet: 'sleet',
  WeatherCondition.hail: 'hail',
  WeatherCondition.thunderstorm: 'thunderstorm',
  WeatherCondition.heavyRain: 'heavyRain',
  WeatherCondition.lightRain: 'lightRain',
  WeatherCondition.showers: 'showers',
  WeatherCondition.heavyCloud: 'heavyCloud',
  WeatherCondition.lightCloud: 'lightCloud',
  WeatherCondition.clear: 'clear',
  WeatherCondition.drizzle: 'drizzle',
  WeatherCondition.unknown: 'unknown',
};

MainClass _$MainClassFromJson(Map<String, dynamic> json) => MainClass(
      temp: (json['temp'] as num?)?.toDouble(),
      tempMin: (json['temp_min'] as num?)?.toDouble(),
      tempMax: (json['temp_max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MainClassToJson(MainClass instance) => <String, dynamic>{
      'temp': instance.temp,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
    };
