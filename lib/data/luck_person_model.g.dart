// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'luck_person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LuckPersonModel _$LuckPersonModelFromJson(
        Map<String, dynamic> json) =>
    LuckPersonModel(
        grade: json['Grade'] as String?,
        name:
            json['Name']
                        .runtimeType ==
                    String
                ? json['Name'] as String?
                : json['Name'].toString(),
        phone: json['Phone'].runtimeType == String
            ? json['Phone'] as String?
            : json['Phone'].toString(),
        userCode: json['User_Code'].runtimeType == String
            ? json['User_Code'] as String?
            : json['User_Code'].toString());

Map<String, dynamic> _$LuckPersonModelToJson(LuckPersonModel instance) =>
    <String, dynamic>{
      'Grade': instance.grade,
      'Name': instance.name,
      'Phone': instance.phone,
      'User_Code': instance.userCode,
    };
