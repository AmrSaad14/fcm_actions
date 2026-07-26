import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'background_dispatcher.dart';
import 'platform_gateways.dart';

final class FirebaseMessagingGateway implements MessagingGateway {
  FirebaseMessagingGateway({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get openedMessages =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  @override
  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Future<void> configureForegroundPresentation() =>
      _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

  @override
  void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(fcmActionsBackgroundMessageHandler);
  }
}
