import 'dart:async';

import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final class FakeMessagingGateway implements MessagingGateway {
  final StreamController<RemoteMessage> foreground =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> opened =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<String> tokens = StreamController<String>.broadcast();

  RemoteMessage? initialMessage;
  String? token = 'fake-fcm-token';
  String? apnsToken;
  String? vapidKey;
  bool permissionRequested = false;
  bool presentationConfigured = false;
  bool backgroundRegistered = false;
  bool supported = true;
  bool tokenDeleted = false;
  NotificationPermission permission = const NotificationPermission(
    status: NotificationAuthorization.authorized,
    alert: true,
    badge: true,
    sound: true,
  );
  final Set<String> topics = <String>{};

  @override
  Stream<RemoteMessage> get foregroundMessages => foreground.stream;

  @override
  Stream<RemoteMessage> get openedMessages => opened.stream;

  @override
  Stream<String> get tokenRefresh => tokens.stream;

  @override
  Future<RemoteMessage?> getInitialMessage() async => initialMessage;

  @override
  Future<NotificationPermission> requestPermission(
    NotificationPermissionRequest request,
  ) async {
    permissionRequested = true;
    return permission;
  }

  @override
  Future<NotificationPermission> getPermissionStatus() async => permission;

  @override
  Future<void> configureForegroundPresentation() async =>
      presentationConfigured = true;

  @override
  void registerBackgroundHandler() => backgroundRegistered = true;

  @override
  Future<String?> getToken({String? vapidKey}) async {
    this.vapidKey = vapidKey;
    return token;
  }

  @override
  Future<String?> getAPNSToken() async => apnsToken;

  @override
  Future<void> deleteToken() async {
    tokenDeleted = true;
    token = null;
  }

  @override
  Future<void> subscribeToTopic(String topic) async => topics.add(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) async => topics.remove(topic);

  @override
  Future<bool> isSupported() async => supported;

  Future<void> dispose() async {
    await foreground.close();
    await opened.close();
    await tokens.close();
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
