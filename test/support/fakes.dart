import 'dart:async';

import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final class FakeMessagingGateway implements MessagingGateway {
  final StreamController<RemoteMessage> foreground =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> opened =
      StreamController<RemoteMessage>.broadcast();

  RemoteMessage? initialMessage;
  bool permissionRequested = false;
  bool presentationConfigured = false;
  bool backgroundRegistered = false;

  @override
  Stream<RemoteMessage> get foregroundMessages => foreground.stream;

  @override
  Stream<RemoteMessage> get openedMessages => opened.stream;

  @override
  Future<RemoteMessage?> getInitialMessage() async => initialMessage;

  @override
  Future<void> requestPermission() async => permissionRequested = true;

  @override
  Future<void> configureForegroundPresentation() async =>
      presentationConfigured = true;

  @override
  void registerBackgroundHandler() => backgroundRegistered = true;

  Future<void> dispose() async {
    await foreground.close();
    await opened.close();
  }
}

final class FakeLocalNotificationsGateway implements LocalNotificationsGateway {
  PlatformNotificationResponse? launchResponse;
  PlatformNotificationResponseCallback? responseCallback;
  final List<NotificationChannel> createdChannels = <NotificationChannel>[];
  final List<NotificationMessage> shown = <NotificationMessage>[];
  final List<int> cancelled = <int>[];
  bool cancelledAll = false;

  @override
  Future<PlatformNotificationResponse?> initialize({
    required String defaultAndroidIcon,
    required bool requestPermission,
    required List<NotificationMessage> categoryTemplates,
    required PlatformNotificationResponseCallback onResponse,
  }) async {
    responseCallback = onResponse;
    return launchResponse;
  }

  @override
  Future<void> createChannels(Iterable<NotificationChannel> channels) async {
    createdChannels.addAll(channels);
  }

  @override
  Future<void> registerCategories(
    Iterable<NotificationMessage> templates,
  ) async {}

  @override
  Future<void> show(
    NotificationMessage message,
    NotificationChannel channel,
  ) async {
    shown.add(message);
  }

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> cancelAll() async => cancelledAll = true;
}
