/// User decision for notification delivery.
enum NotificationAuthorization {
  /// Notifications may be presented.
  authorized,

  /// The user refused notifications.
  denied,

  /// The user refused notifications and the OS will not prompt again.
  deniedPermanently,

  /// The user has not been asked yet.
  notDetermined,

  /// Quiet delivery is allowed (Apple provisional).
  provisional,

  /// Temporary authorization (Apple ephemeral).
  ephemeral,
}

/// Cross-platform snapshot of notification permission.
final class NotificationPermission {
  /// Creates a permission snapshot.
  const NotificationPermission({
    required this.status,
    this.alert = false,
    this.badge = false,
    this.sound = false,
    this.announcement = false,
    this.carPlay = false,
    this.criticalAlert = false,
    this.providesAppNotificationSettings = false,
    this.timeSensitive = false,
  });

  /// Permission has not been requested or could not be read.
  static const NotificationPermission undetermined = NotificationPermission(
    status: NotificationAuthorization.notDetermined,
  );

  /// Overall authorization decision.
  final NotificationAuthorization status;

  /// Whether alert presentation is enabled.
  final bool alert;

  /// Whether badge updates are enabled.
  final bool badge;

  /// Whether notification sounds are enabled.
  final bool sound;

  /// Whether announcement (Siri) delivery is enabled.
  final bool announcement;

  /// Whether CarPlay presentation is enabled.
  final bool carPlay;

  /// Whether critical alerts are enabled.
  final bool criticalAlert;

  /// Whether the system can open the app notification settings.
  final bool providesAppNotificationSettings;

  /// Whether time-sensitive notifications are enabled.
  final bool timeSensitive;

  /// Whether the OS will deliver notifications to this app instance.
  bool get granted =>
      status == NotificationAuthorization.authorized ||
      status == NotificationAuthorization.provisional ||
      status == NotificationAuthorization.ephemeral;

  @override
  String toString() =>
      'NotificationPermission(status: ${status.name}, granted: $granted)';
}

/// Options forwarded to the platform permission prompt.
final class NotificationPermissionRequest {
  /// Creates a permission request. Defaults match Firebase Messaging.
  const NotificationPermissionRequest({
    this.alert = true,
    this.announcement = false,
    this.badge = true,
    this.carPlay = false,
    this.criticalAlert = false,
    this.provisional = false,
    this.sound = true,
  });

  /// Request alert presentation.
  final bool alert;

  /// Request announcement (Siri) delivery.
  final bool announcement;

  /// Request badge updates.
  final bool badge;

  /// Request CarPlay presentation.
  final bool carPlay;

  /// Request critical alerts.
  final bool criticalAlert;

  /// Request Apple provisional (quiet) authorization.
  final bool provisional;

  /// Request notification sounds.
  final bool sound;
}
