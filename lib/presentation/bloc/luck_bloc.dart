import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waso_ticket_system/data/luck_person_model.dart';
import 'package:waso_ticket_system/data/repo/luck_repo.dart';

import '../../core/failure.dart';

part 'luck_event.dart';
part 'luck_state.dart';

class LuckBloc extends Bloc<LuckEvent, LuckState> {
  final ILuckRepo iLuckRepo;
  LuckBloc(this.iLuckRepo) : super(LuckState(status: LuckStatus.initial)) {
    on<InitLuckEvent>(
      (event, emit) async {
        emit(state.copyWith(status: LuckStatus.loading));
        final data = await iLuckRepo.getAllLuck();

        data.fold((l) {
          if (l is LogicFailure) {
            print(l);
          }
        }, (r) async {
          print(r.length);
          emit(state.copyWith(status: LuckStatus.data, personList: r));
        });
      },
    );

    on<SelectLuckState>(
      (event, emit) {
        emit(state.copyWith(status: LuckStatus.selecting));
      },
    );

    on<ShowLuckPeople>(
      (event, emit) {
        print(event.model.toJson());
        emit(state.copyWith(status: LuckStatus.selected, person: event.model));
      },
    );
  }
}
