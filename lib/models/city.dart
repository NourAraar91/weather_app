class City {
  double lat;
  double lon;
  String? name;

  City({required this.lat, required this.lon, this.name});

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["city"],
        lat: json["lat"],
        lon: json["lng"],
      );
}
