part of 'luck_bloc.dart';

enum LuckStatus { initial, loading, data, selecting, selected }

class LuckState {
  final LuckStatus status;
  final List<LuckPersonModel>? personList;
  final String? error;
  final int? index;
  final LuckPersonModel? person;

  LuckState({
    required this.status,
    this.personList,
    this.error,
    this.index,
    this.person,
  });

  LuckState copyWith(
      {LuckStatus? status,
      List<LuckPersonModel>? personList,
      String? error,
      bool? isRotating,
      int? index,
      LuckPersonModel? person}) {
    return LuckState(
      status: status ?? this.status,
      index: index ?? this.index,
      personList: personList ?? this.personList,
      error: error ?? this.error,
      person: person ?? this.person,
    );
  }
}
