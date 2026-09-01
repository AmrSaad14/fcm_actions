/// Base class for recoverable package failures.
class FcmActionsException implements Exception {
  /// Creates a package exception with a human-readable [message].
  const FcmActionsException(this.message, {this.cause});

  /// Description of the failure.
  final String message;

  /// Optional underlying error.
  final Object? cause;

  @override
  String toString() =>
      'FcmActionsException: $message${cause == null ? '' : ' ($cause)'}';
}

/// Firebase, plugin, or binding setup failed.
final class FcmActionsInitializationException extends FcmActionsException {
  /// Creates an initialization failure.
  const FcmActionsInitializationException(super.message, {super.cause});
}

/// A payload failed validation or could not be parsed.
final class InvalidNotificationPayloadException extends FcmActionsException {
  /// Creates a payload validation failure.
  const InvalidNotificationPayloadException(super.message, {super.cause});
}

/// A message or action was already processed inside the replay window.
final class DuplicateNotificationException extends FcmActionsException {
  /// Creates a duplicate-identity failure.
  const DuplicateNotificationException(super.message);
}

/// An action id was referenced without a registered definition.
final class UnregisteredActionException extends FcmActionsException {
  /// Creates an unregistered-action failure.
  const UnregisteredActionException(super.message);
}
