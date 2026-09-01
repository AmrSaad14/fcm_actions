import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/configuration_models.dart';
import '../models/notification_message.dart';
import '../models/notification_permission.dart';

typedef PlatformNotificationResponseCallback =
    Future<void> Function(PlatformNotificationResponse response);

final class PlatformNotificationResponse {
  const PlatformNotificationResponse({
    required this.notificationId,
    required this.payload,
    required this.actionId,
    required this.input,
    required this.dismissed,
    required this.launchedApp,
    required this.fromBackground,
  });

  final int? notificationId;
  final String? payload;
  final String? actionId;
  final String? input;
  final bool dismissed;
  final bool launchedApp;
  final bool fromBackground;
}

/// Platform seam for Firebase Cloud Messaging.
abstract interface class MessagingGateway {
  /// Foreground FCM messages.
  Stream<RemoteMessage> get foregroundMessages;

  /// Notification taps that resume the app.
  Stream<RemoteMessage> get openedMessages;

  /// FCM token rotations, including the current token at subscribe time.
  Stream<String> get tokenRefresh;

  /// Message that launched a terminated app, if any.
  Future<RemoteMessage?> getInitialMessage();

  /// Prompts the user when required and returns the resulting status.
  Future<NotificationPermission> requestPermission(
    NotificationPermissionRequest request,
  );

  /// Reads the current permission without prompting.
  Future<NotificationPermission> getPermissionStatus();

  /// Disables the OS banner so local notifications own the foreground UI.
  Future<void> configureForegroundPresentation();

  /// Registers the package background handler. No-op on web.
  void registerBackgroundHandler();

  /// Current FCM registration token.
  Future<String?> getToken({String? vapidKey});

  /// Apple Push Notification service token, or `null` on other platforms.
  Future<String?> getAPNSToken();

  /// Invalidates the current FCM token.
  Future<void> deleteToken();

  /// Subscribes this app instance to an FCM topic.
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribes this app instance from an FCM topic.
  Future<void> unsubscribeFromTopic(String topic);

  /// Whether FCM can run on this platform/browser.
  Future<bool> isSupported();
}

abstract interface class LocalNotificationsGateway {
  Future<PlatformNotificationResponse?> initialize({
    required String defaultAndroidIcon,
    required bool requestPermission,
    required List<NotificationMessage> categoryTemplates,
    required PlatformNotificationResponseCallback onResponse,
  });

  Future<void> createChannels(Iterable<NotificationChannel> channels);

  Future<void> registerCategories(Iterable<NotificationMessage> templates);

  Future<void> show(NotificationMessage message, NotificationChannel channel);

  Future<void> cancel(int id);
  Future<void> cancelAll();
}
