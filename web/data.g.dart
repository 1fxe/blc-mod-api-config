// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      json['clicksPerSecondLimitRight'] as int,
      json['clicksPerSecondLimit'] as int,
      (json['modsDisallowed'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, DisallowedMod.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'clicksPerSecondLimitRight': instance.clicksPerSecondLimitRight,
      'clicksPerSecondLimit': instance.clicksPerSecondLimit,
      'modsDisallowed': instance.modsDisallowed,
    };

JsonBoolean _$JsonBooleanFromJson(Map<String, dynamic> json) => JsonBoolean(
      json['disabled'] as bool,
    );

Map<String, dynamic> _$JsonBooleanToJson(JsonBoolean instance) =>
    <String, dynamic>{
      'disabled': instance.disabled,
    };

DisallowedMod _$DisallowedModFromJson(Map<String, dynamic> json) =>
    DisallowedMod(
      json['disabled'] as bool?,
    )..extraData = (json['extra_data'] as List<dynamic>?)
        ?.map((e) => JsonBoolean.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$DisallowedModToJson(DisallowedMod instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('disabled', instance.disabled);
  writeNotNull('extra_data', instance.extraData);
  return val;
}
