import 'dart:convert';

import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'support/fake_preferences.dart';
import 'support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeMessagingGateway messaging;
  late FakeLocalNotificationsGateway local;
  late FcmActionsClient client;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance = FakeSharedPreferencesAsync();
    messaging = FakeMessagingGateway();
    local = FakeLocalNotificationsGateway();
    const config = FcmActionsConfig(
      initializeFirebase: false,
      requestPermission: false,
    );
    final engine = NotificationEngine(
      config: config,
      messaging: messaging,
      localNotifications: local,
    );
    client = FcmActionsClient(config, engine: engine);
    await client.initialize();
  });

  tearDown(() async {
    await client.dispose();
    await messaging.dispose();
    SharedPreferencesAsyncPlatform.instance = null;
  });

  test('initializes adapters and predefined channels', () {
    expect(messaging.backgroundRegistered, isTrue);
    expect(messaging.presentationConfigured, isTrue);
    expect(messaging.permissionRequested, isFalse);
    expect(local.createdChannels, hasLength(5));
  });

  test(
    'normalizes foreground FCM data and displays a local fallback',
    () async {
      final eventFuture = client.onForegroundMessage.first;
      messaging.foreground.add(
        const RemoteMessage(
          messageId: 'foreground-1',
          data: <String, dynamic>{
            'title': 'Data message',
            'body': 'Rendered locally',
          },
        ),
      );

      final event = await eventFuture;
      await Future<void>.delayed(Duration.zero);
      expect(event.message.messageId, 'foreground-1');
      expect(event.state, NotificationState.foreground);
      expect(local.shown.single.title, 'Data message');
    },
  );

  test('executes action handler once and emits reply text', () async {
    var executions = 0;
    client.registerAction(
      const NotificationAction(id: 'reply', title: 'Reply', input: true),
      handler: (_) async => executions++,
    );
    final message = client.parse(<String, Object?>{
      'message_id': 'reply-1',
      'notification_id': 10,
      'title': 'Message',
    });
    final replyFuture = client.onReply.first;
    final response = PlatformNotificationResponse(
      notificationId: 10,
      payload: jsonEncode(message.toJson()),
      actionId: 'reply',
      input: 'On my way',
      dismissed: false,
      launchedApp: false,
      fromBackground: false,
    );

    await local.responseCallback!(response);
    await local.responseCallback!(response);
    final reply = await replyFuture;

    expect(reply.replyText, 'On my way');
    expect(executions, 1);
  });

  test('emits dismissal without running an action', () async {
    final message = client.parse(<String, Object?>{
      'message_id': 'dismiss-1',
      'notification_id': 20,
    });
    final dismissalFuture = client.onDismiss.first;

    await local.responseCallback!(
      PlatformNotificationResponse(
        notificationId: 20,
        payload: jsonEncode(message.toJson()),
        actionId: null,
        input: null,
        dismissed: true,
        launchedApp: false,
        fromBackground: false,
      ),
    );

    expect((await dismissalFuture).message.notificationId, 20);
  });

  test('returns token and permission from initialize', () {
    expect(client.lastResult?.token, 'fake-fcm-token');
    expect(client.lastResult?.authorized, isTrue);
    expect(client.lastResult?.supported, isTrue);
  });

  test('subscribes and unsubscribes from topics', () async {
    await client.subscribeToTopic('orders');
    expect(messaging.topics, contains('orders'));
    await client.unsubscribeFromTopic('orders');
    expect(messaging.topics, isEmpty);
  });

  test('exposes token refresh and permission status', () async {
    final refresh = client.onTokenRefresh.first;
    messaging.tokens.add('rotated-token');
    expect(await refresh, 'rotated-token');
    expect((await client.getPermissionStatus()).granted, isTrue);
    await client.deleteToken();
    expect(messaging.tokenDeleted, isTrue);
  });

  test('unregisters actions', () {
    client.registerAction(const NotificationAction(id: 'temp', title: 'Temp'));
    client.unregisterAction('temp');
    expect(
      () => client.parse(<String, Object?>{
        'actions': <Object?>['temp'],
      }),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
  });
}
