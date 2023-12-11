import 'package:waso_ticket_system/domain/luck_person.dart';
import 'package:json_annotation/json_annotation.dart';

part "luck_person_model.g.dart";

@JsonSerializable()
class LuckPersonModel implements LuckPerson {
  @override
  @JsonKey(name: "Grade")
  final String? grade;

  @override
  @JsonKey(name: "Name")
  final String? name;

  @override
  @JsonKey(name: "Phone")
  final String? phone;

  @override
  @JsonKey(name: "User_Code")
  final String? userCode;

  LuckPersonModel({this.grade, this.name, this.phone, this.userCode});

  factory LuckPersonModel.fromJson(Map<String, dynamic> json) =>
      _$LuckPersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LuckPersonModelToJson(this);
}
//  {
//   "Name": "Aung Kyaw Thann",
//   "User_Code": "125900304A",
//   "Phone": "09254043559",
//   "Grade": "Grade 11 (တက္ကသိုလ်ဝင်တန်း)"
//  },