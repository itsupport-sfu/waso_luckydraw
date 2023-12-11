import 'package:flutter_bloc/flutter_bloc.dart';
part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeOpenState()) {
    on<ActionWelcomeEvent>(
      (event, emit) {
        if (state is! WelcomeCloseState) {
          emit(WelcomeCloseState());
        } else {
          emit(WelcomeOpenState());
        }
      },
    );
  }
}
