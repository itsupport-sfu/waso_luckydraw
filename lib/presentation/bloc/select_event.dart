part of 'select_bloc.dart';

abstract class SelectEvent {}

class SelectLuckDraw extends SelectEvent {
  final int status;

  SelectLuckDraw(this.status);
}
