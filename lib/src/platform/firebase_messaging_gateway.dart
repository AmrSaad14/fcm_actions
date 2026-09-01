import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../core/exceptions.dart';
import '../models/notification_permission.dart';
import 'background_dispatcher.dart';
import 'platform_gateways.dart';

final _topicPattern = RegExp(r'^[a-zA-Z0-9\-_.~%]{1,900}$');

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
  Stream<String> get tokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  @override
  Future<NotificationPermission> requestPermission(
    NotificationPermissionRequest request,
  ) async {
    final settings = await _messaging.requestPermission(
      alert: request.alert,
      announcement: request.announcement,
      badge: request.badge,
      carPlay: request.carPlay,
      criticalAlert: request.criticalAlert,
      provisional: request.provisional,
      sound: request.sound,
    );
    return _mapPermission(settings);
  }

  @override
  Future<NotificationPermission> getPermissionStatus() async {
    return _mapPermission(await _messaging.getNotificationSettings());
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
    if (kIsWeb) return;
    FirebaseMessaging.onBackgroundMessage(fcmActionsBackgroundMessageHandler);
  }

  @override
  Future<String?> getToken({String? vapidKey}) async {
    if (!await isSupported()) return null;
    if (_isApplePlatform) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null) return null;
    }
    return _messaging.getToken(vapidKey: vapidKey);
  }

  @override
  Future<String?> getAPNSToken() async {
    if (!_isApplePlatform) return null;
    return _messaging.getAPNSToken();
  }

  @override
  Future<void> deleteToken() => _messaging.deleteToken();

  @override
  Future<void> subscribeToTopic(String topic) async {
    validateTopic(topic);
    if (kIsWeb) {
      throw const FcmActionsException(
        'FCM topic subscriptions are not supported on web.',
      );
    }
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    validateTopic(topic);
    if (kIsWeb) {
      throw const FcmActionsException(
        'FCM topic subscriptions are not supported on web.',
      );
    }
    await _messaging.unsubscribeFromTopic(topic);
  }

  @override
  Future<bool> isSupported() => _messaging.isSupported();

  Future<String?> _waitForApnsToken() async {
    var token = await _messaging.getAPNSToken();
    if (token != null) return token;
    for (var attempt = 1; attempt <= 5; attempt++) {
      await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
      token = await _messaging.getAPNSToken();
      if (token != null) return token;
    }
    return null;
  }

  static bool get _isApplePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  /// Validates an FCM topic name without contacting Firebase.
  static void validateTopic(String topic) {
    if (!_topicPattern.hasMatch(topic)) {
      throw InvalidNotificationPayloadException(
        'Invalid FCM topic "$topic". Use 1-900 characters from '
        'A-Z, a-z, 0-9, "-", "_", ".", "~", or "%".',
      );
    }
  }

  static NotificationPermission _mapPermission(NotificationSettings settings) {
    return NotificationPermission(
      status: switch (settings.authorizationStatus) {
        AuthorizationStatus.authorized => NotificationAuthorization.authorized,
        AuthorizationStatus.denied => NotificationAuthorization.denied,
        AuthorizationStatus.deniedPermanently =>
          NotificationAuthorization.deniedPermanently,
        AuthorizationStatus.notDetermined =>
          NotificationAuthorization.notDetermined,
        AuthorizationStatus.provisional =>
          NotificationAuthorization.provisional,
      },
      alert: settings.alert == AppleNotificationSetting.enabled,
      badge: settings.badge == AppleNotificationSetting.enabled,
      sound: settings.sound == AppleNotificationSetting.enabled,
      announcement: settings.announcement == AppleNotificationSetting.enabled,
      carPlay: settings.carPlay == AppleNotificationSetting.enabled,
      criticalAlert: settings.criticalAlert == AppleNotificationSetting.enabled,
      providesAppNotificationSettings:
          settings.providesAppNotificationSettings ==
          AppleNotificationSetting.enabled,
      timeSensitive: settings.timeSensitive == AppleNotificationSetting.enabled,
    );
  }
}
