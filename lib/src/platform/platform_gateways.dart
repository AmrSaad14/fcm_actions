import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/configuration_models.dart';
import '../models/notification_message.dart';

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

abstract interface class MessagingGateway {
  Stream<RemoteMessage> get foregroundMessages;
  Stream<RemoteMessage> get openedMessages;

  Future<RemoteMessage?> getInitialMessage();
  Future<void> requestPermission();
  Future<void> configureForegroundPresentation();
  void registerBackgroundHandler();
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
