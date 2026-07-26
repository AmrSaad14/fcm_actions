/// Base class for recoverable package failures.
class FcmActionsException implements Exception {
  const FcmActionsException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() =>
      'FcmActionsException: $message${cause == null ? '' : ' ($cause)'}';
}

final class FcmActionsInitializationException extends FcmActionsException {
  const FcmActionsInitializationException(super.message, {super.cause});
}

final class InvalidNotificationPayloadException extends FcmActionsException {
  const InvalidNotificationPayloadException(super.message, {super.cause});
}

final class DuplicateNotificationException extends FcmActionsException {
  const DuplicateNotificationException(super.message);
}

final class UnregisteredActionException extends FcmActionsException {
  const UnregisteredActionException(super.message);
}
