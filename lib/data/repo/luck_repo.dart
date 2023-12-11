import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:waso_ticket_system/core/failure.dart';
import 'package:waso_ticket_system/data/luck_person_model.dart';
import 'package:waso_ticket_system/domain/repo/luck_repo.dart';

class ILuckRepo implements LuckRepo {
  @override
  Future<Either<Failure, List<LuckPersonModel>>> getAllLuck() async {
    try {
      final String response =
          await rootBundle.loadString("assets/luckydraw.json");
      var userJson = json.decode(response);
      List<LuckPersonModel> personList = userJson
          .map<LuckPersonModel>((json) => LuckPersonModel.fromJson(json))
          .toList();
      return Right(personList);
    } catch (e) {
      return Left(LogicFailure(e.toString()));
    }
  }
}
