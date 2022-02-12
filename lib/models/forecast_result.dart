import 'package:json_annotation/json_annotation.dart';

part 'forecast_result.g.dart';

@JsonSerializable()
class ForcastResult {
  ForcastResult();

  factory ForcastResult.fromJson(Map<String, dynamic> json) =>
      _$ForcastResultFromJson(json);
  Map<String, dynamic> toJson() => _$ForcastResultToJson(this);
}
