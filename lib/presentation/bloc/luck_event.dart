part of 'luck_bloc.dart';

abstract class LuckEvent {}

class SelectLuckState extends LuckEvent {}

class ShowLuckPeople extends LuckEvent {
  final LuckPersonModel model;

  ShowLuckPeople(this.model);
}

class InitLuckEvent extends LuckEvent {}
