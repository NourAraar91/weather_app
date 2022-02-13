import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/models/weather.dart';

part 'forecast_result.g.dart';

@JsonSerializable()
class ForcastResult {
  ForcastResult({
    required this.list,
    required this.city,
  });

  List<CurrentWeather> list;
  Place city;

  factory ForcastResult.fromJson(Map<String, dynamic> json) =>
      _$ForcastResultFromJson(json);
  Map<String, dynamic> toJson() => _$ForcastResultToJson(this);
}

@JsonSerializable()
class Place extends Equatable implements Comparable {
  final Coord coord;
  final String name;

  const Place({
    required this.coord,
    required this.name,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  factory Place.fromMap(Map<String, dynamic> json) =>
      Place(name: json["city"], coord: Coord.fromJson(json));

  Map<String, dynamic> toMap() => {
        "city": name,
        "coord": coord.toJson(),
      };

  @override
  List<Object?> get props => [name];

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}

@JsonSerializable()
class Coord {
  Coord({
    required this.lat,
    required this.lon,
  });

  double lat;
  double lon;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}
