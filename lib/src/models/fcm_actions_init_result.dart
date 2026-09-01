import 'notification_permission.dart';

/// Outcome of [FcmActions.initialize] / [FcmActionsClient.initialize].
final class FcmActionsInitResult {
  /// Creates an initialization result.
  const FcmActionsInitResult({
    required this.permission,
    this.token,
    this.apnsToken,
    this.supported = true,
  });

  /// Result used when initialization did not complete.
  const FcmActionsInitResult.unavailable()
    : permission = NotificationPermission.undetermined,
      token = null,
      apnsToken = null,
      supported = false;

  /// Notification permission after initialize.
  final NotificationPermission permission;

  /// Current FCM registration token, if one could be fetched.
  final String? token;

  /// Apple Push Notification service token, if available.
  final String? apnsToken;

  /// Whether FCM is supported on this platform/browser.
  final bool supported;

  /// Whether notifications are authorized for this app instance.
  bool get authorized => permission.granted;

  @override
  String toString() =>
      'FcmActionsInitResult(authorized: $authorized, '
      'supported: $supported, hasToken: ${token != null})';
}
