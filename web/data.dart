import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Config {
  final int clicksPerSecondLimitRight;
  final int clicksPerSecondLimit;
  final Map<String, DisallowedMod> modsDisallowed;

  Config(this.clicksPerSecondLimitRight, this.clicksPerSecondLimit,
      this.modsDisallowed);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}

// https://github.com/BadlionClient/BadlionClientModAPI/blob/007f5e91a8dd89e2d03af15abc81a80bd1b83911/modapi-common/src/main/java/net/badlion/modapicommon/Config.java#L30C22-L30C32
@JsonSerializable()
class JsonBoolean {
  final bool disabled;

  const JsonBoolean(this.disabled);

  factory JsonBoolean.fromJson(Map<String, dynamic> json) =>
      _$JsonBooleanFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBooleanToJson(this);
}

@JsonSerializable()
class DisallowedMod {
  @JsonKey(includeIfNull: false, disallowNullValue: false)
  final bool? disabled;
  @JsonKey(name: "extra_data", includeIfNull: false, disallowNullValue: false)
  List<JsonBoolean>? extraData;

  DisallowedMod(this.disabled);

  factory DisallowedMod.fromJson(Map<String, dynamic> json) =>
      _$DisallowedModFromJson(json);

  Map<String, dynamic> toJson() => _$DisallowedModToJson(this);
}
