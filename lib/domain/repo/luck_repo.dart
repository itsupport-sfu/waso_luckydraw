import 'package:dartz/dartz.dart';
import 'package:waso_ticket_system/data/luck_person_model.dart';

import '../../core/failure.dart';

abstract class LuckRepo {
  Future<Either<Failure, List<LuckPersonModel>>> getAllLuck();
}
