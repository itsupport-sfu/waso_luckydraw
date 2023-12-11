part of 'select_bloc.dart';

enum SelectStatus { loaded, loading }

class SelectState {
  final SelectStatus? status;
  final int? id;

  SelectState({this.status, this.id});

  SelectState copyWith({
    SelectStatus? status,
    int? id,
  }) {
    return SelectState(status: status ?? this.status, id: id ?? this.id);
  }
}
