abstract class Failure {}

class LogicFailure extends Failure {
  final String message;

  LogicFailure(this.message);
}
