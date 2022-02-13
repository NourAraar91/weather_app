class City implements Comparable {
  double lat;
  double lon;
  String name;

  City({
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
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
