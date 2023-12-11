import 'package:flutter_bloc/flutter_bloc.dart';

part 'select_event.dart';
part 'select_state.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState> {
  SelectBloc() : super(SelectState(status: SelectStatus.loaded, id: 1)) {
    on<SelectLuckDraw>((event, emit) async {
      emit(state.copyWith(status: SelectStatus.loading));
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(state.copyWith(status: SelectStatus.loaded, id: event.status));
    });
  }
}
