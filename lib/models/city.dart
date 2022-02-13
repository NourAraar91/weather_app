import 'package:equatable/equatable.dart';

class City extends Equatable implements Comparable {
  final double lat;
  final double lon;
  final String name;

  const City({
    required this.lat,
    required this.lon,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["city"],
        lat: json["lat"],
        lon: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "city": name,
        "lat": lat,
        "lng": lon,
      };
  @override
  List<Object?> get props => [name];

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
