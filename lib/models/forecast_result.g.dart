// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastResult _$ForecastResultFromJson(Map<String, dynamic> json) =>
    ForecastResult(
      list: (json['list'] as List<dynamic>)
          .map((e) => CurrentWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: Place.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastResultToJson(ForecastResult instance) =>
    <String, dynamic>{
      'list': instance.list,
      'city': instance.city,
    };

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'coord': instance.coord,
      'name': instance.name,
    };

Coord _$CoordFromJson(Map<String, dynamic> json) => Coord(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordToJson(Coord instance) => <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
