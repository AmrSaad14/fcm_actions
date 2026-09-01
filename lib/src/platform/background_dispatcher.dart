import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions/action_registry.dart';
import '../core/contracts.dart';
import '../core/fcm_actions_config.dart';
import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/events.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import '../parser/notification_parser.dart';
import '../services/replay_guard.dart';
import '../utils/platform_utils.dart';
import 'local_notifications_gateway.dart';

const String _configurationKey = 'fcm_actions.background_config.v1';
const String _pendingEventsKey = 'fcm_actions.pending_events.v1';
const String _pendingActionsKey = 'fcm_actions.pending_actions.v1';

/// Persists the isolate-safe portion of configuration.
final class BackgroundDispatcher {
  const BackgroundDispatcher._();

  static Future<void> configure(
    FcmActionsConfig config, {
    Iterable<NotificationAction>? actions,
    Iterable<NotificationChannel>? channels,
  }) async {
    final callback = config.backgroundActionHandler;
    final handle = callback == null
        ? null
        : PluginUtilities.getCallbackHandle(callback);
    if (!kIsWeb && callback != null && handle == null) {
      throw ArgumentError(
        'backgroundActionHandler must be a top-level or static function.',
      );
    }

    final preferences = SharedPreferencesAsync();
    await preferences.setString(
      _configurationKey,
      jsonEncode(<String, Object?>{
        'icon': config.defaultAndroidIcon,
        'defaultChannelId': config.defaultChannelId,
        'maxPayloadBytes': config.maxPayloadBytes,
        'replayWindowMs': config.replayProtectionWindow.inMilliseconds,
        'actions': (actions ?? config.actions)
            .map((action) => action.toJson())
            .toList(),
        'channels': (channels ?? config.channels)
            .map((channel) => channel.toJson())
            .toList(),
        'callbackHandle': handle?.toRawHandle(),
        if (config.firebaseOptions != null)
          'firebaseOptions': _firebaseOptionsToJson(config.firebaseOptions!),
        if (config.firebaseAppName != null)
          'firebaseAppName': config.firebaseAppName,
      }),
    );
  }

  static Future<List<NotificationEvent>> takePendingNotifications() async {
    final preferences = SharedPreferencesAsync();
    final encoded = await preferences.getString(_pendingEventsKey);
    await preferences.remove(_pendingEventsKey);
    if (encoded == null) return const <NotificationEvent>[];
    try {
      final values = jsonDecode(encoded);
      if (values is! List) return const <NotificationEvent>[];
      return values
          .whereType<Map<Object?, Object?>>()
          .map(
            (value) => NotificationEvent.fromJson(
              value.map((key, item) => MapEntry(key.toString(), item)),
            ),
          )
          .toList();
    } on Object {
      return const <NotificationEvent>[];
    }
  }

  static Future<List<NotificationActionEvent>> takePendingActions() async {
    final preferences = SharedPreferencesAsync();
    final encoded = await preferences.getString(_pendingActionsKey);
    await preferences.remove(_pendingActionsKey);
    if (encoded == null) return const <NotificationActionEvent>[];
    try {
      final values = jsonDecode(encoded);
      if (values is! List) return const <NotificationActionEvent>[];
      return values
          .whereType<Map<Object?, Object?>>()
          .map(
            (value) => NotificationActionEvent.fromJson(
              value.map((key, item) => MapEntry(key.toString(), item)),
            ),
          )
          .toList();
    } on Object {
      return const <NotificationActionEvent>[];
    }
  }

  static Future<void> _appendPending(NotificationEvent event) async {
    final preferences = SharedPreferencesAsync();
    final encoded = await preferences.getString(_pendingEventsKey);
    final list = <Object?>[];
    if (encoded != null) {
      try {
        final existing = jsonDecode(encoded);
        if (existing is List) list.addAll(existing);
      } on Object {
        // Replace corrupted internal state.
      }
    }
    list.add(event.toJson());
    if (list.length > 100) list.removeRange(0, list.length - 100);
    await preferences.setString(_pendingEventsKey, jsonEncode(list));
  }

  static Future<void> _appendPendingAction(
    NotificationActionEvent event,
  ) async {
    final preferences = SharedPreferencesAsync();
    final encoded = await preferences.getString(_pendingActionsKey);
    final list = <Object?>[];
    if (encoded != null) {
      try {
        final existing = jsonDecode(encoded);
        if (existing is List) list.addAll(existing);
      } on Object {
        // Replace corrupted internal state.
      }
    }
    list.add(event.toJson());
    if (list.length > 100) list.removeRange(0, list.length - 100);
    await preferences.setString(_pendingActionsKey, jsonEncode(list));
  }

  static Future<Map<String, Object?>?> _readConfiguration() async {
    final encoded = await SharedPreferencesAsync().getString(_configurationKey);
    if (encoded == null) return null;
    final value = jsonDecode(encoded);
    return value is Map
        ? value.map((key, item) => MapEntry(key.toString(), item))
        : null;
  }

  static Map<String, Object?> _firebaseOptionsToJson(
    FirebaseOptions options,
  ) => <String, Object?>{
    'apiKey': options.apiKey,
    'appId': options.appId,
    'messagingSenderId': options.messagingSenderId,
    'projectId': options.projectId,
    if (options.authDomain != null) 'authDomain': options.authDomain,
    if (options.databaseURL != null) 'databaseURL': options.databaseURL,
    if (options.storageBucket != null) 'storageBucket': options.storageBucket,
    if (options.measurementId != null) 'measurementId': options.measurementId,
    if (options.trackingId != null) 'trackingId': options.trackingId,
    if (options.deepLinkURLScheme != null)
      'deepLinkURLScheme': options.deepLinkURLScheme,
    if (options.androidClientId != null)
      'androidClientId': options.androidClientId,
    if (options.iosClientId != null) 'iosClientId': options.iosClientId,
    if (options.iosBundleId != null) 'iosBundleId': options.iosBundleId,
    if (options.appGroupId != null) 'appGroupId': options.appGroupId,
  };

  static FirebaseOptions _firebaseOptionsFromJson(Map<String, Object?> json) =>
      FirebaseOptions(
        apiKey: json['apiKey']! as String,
        appId: json['appId']! as String,
        messagingSenderId: json['messagingSenderId']! as String,
        projectId: json['projectId']! as String,
        authDomain: json['authDomain'] as String?,
        databaseURL: json['databaseURL'] as String?,
        storageBucket: json['storageBucket'] as String?,
        measurementId: json['measurementId'] as String?,
        trackingId: json['trackingId'] as String?,
        deepLinkURLScheme: json['deepLinkURLScheme'] as String?,
        androidClientId: json['androidClientId'] as String?,
        iosClientId: json['iosClientId'] as String?,
        iosBundleId: json['iosBundleId'] as String?,
        appGroupId: json['appGroupId'] as String?,
      );
}

@pragma('vm:entry-point')
Future<void> fcmActionsBackgroundMessageHandler(RemoteMessage remote) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    final config = await BackgroundDispatcher._readConfiguration();
    if (config == null) return;
    if (Firebase.apps.isEmpty) {
      final optionsValue = config['firebaseOptions'];
      await Firebase.initializeApp(
        name: config['firebaseAppName'] as String?,
        options: optionsValue is Map<Object?, Object?>
            ? BackgroundDispatcher._firebaseOptionsFromJson(
                optionsValue.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
              )
            : null,
      );
    }

    final registry = ActionRegistry();
    final actionValues = config['actions'];
    if (actionValues is List) {
      registry.registerAll(
        actionValues.whereType<Map<Object?, Object?>>().map(
          (value) => NotificationAction.fromJson(
            value.map((key, item) => MapEntry(key.toString(), item)),
          ),
        ),
      );
    }
    final parser = NotificationParser(
      maxPayloadBytes: config['maxPayloadBytes'] as int? ?? 32768,
      defaultChannelId:
          config['defaultChannelId'] as String? ?? 'fcm_actions_default',
      resolveAction: registry.find,
    );
    final message = parser.parseRemoteMessage(remote);
    final event = NotificationEvent(
      message: message,
      timestamp: DateTime.now().toUtc(),
      platform: currentNotificationPlatform,
      state: NotificationState.background,
      rawJson: message.rawJson,
    );
    await BackgroundDispatcher._appendPending(event);

    // Notification/mixed messages are already rendered by the OS in the
    // background. Only data-only, non-silent messages need local fallback.
    if (remote.notification == null && !message.silent) {
      final channels = (config['channels'] as List? ?? const <Object?>[])
          .whereType<Map<Object?, Object?>>()
          .map(
            (value) => NotificationChannel.fromJson(
              value.map((key, item) => MapEntry(key.toString(), item)),
            ),
          )
          .toList();
      NotificationChannel? channel;
      for (final item in channels) {
        if (item.id == message.channelId) {
          channel = item;
          break;
        }
      }
      final fallback = channel ?? NotificationChannel.defaultChannel;
      final local = FlutterLocalNotificationsGateway();
      await local.initialize(
        defaultAndroidIcon: config['icon'] as String? ?? '@mipmap/ic_launcher',
        requestPermission: false,
        categoryTemplates: <NotificationMessage>[message],
        onResponse: (_) async {},
      );
      await local.createChannels(<NotificationChannel>[fallback]);
      await local.show(message, fallback);
    }
  } on Object {
    // Background callbacks must never terminate the host application.
  }
}

@pragma('vm:entry-point')
void fcmActionsBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    if (response.payload == null) return;
    final message = NotificationMessage.fromJson(
      Map<String, Object?>.from(jsonDecode(response.payload!) as Map),
    );
    final event = NotificationActionEvent(
      actionId: response.actionId ?? 'default',
      notificationId: response.id ?? message.notificationId,
      timestamp: DateTime.now().toUtc(),
      message: message,
      platform: currentNotificationPlatform,
      state: NotificationState.background,
      payload: message.data,
      rawJson: message.rawJson,
      replyText: response.input,
      fromBackground: true,
    );
    final config = await BackgroundDispatcher._readConfiguration();
    if (config == null) return;
    final claimed =
        await ReplayGuard(
          window: Duration(
            milliseconds:
                config['replayWindowMs'] as int? ??
                const Duration(days: 7).inMilliseconds,
          ),
        ).claim(
          'action:${event.notificationId}:${event.actionId}:'
          '${event.message.messageId}',
          event.timestamp,
        );
    if (!claimed) return;
    final rawHandle = config['callbackHandle'];
    if (rawHandle is int) {
      final callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(rawHandle),
      );
      if (callback is NotificationActionCallback) {
        try {
          await callback(event);
          return;
        } on Object {
          await BackgroundDispatcher._appendPendingAction(event);
        }
      } else {
        await BackgroundDispatcher._appendPendingAction(event);
      }
    } else {
      await BackgroundDispatcher._appendPendingAction(event);
    }
    await BackgroundDispatcher._appendPending(
      NotificationEvent(
        message: message,
        timestamp: event.timestamp,
        platform: event.platform,
        state: event.state,
        interaction: response.input == null
            ? NotificationInteraction.actionTap
            : NotificationInteraction.reply,
        rawJson: event.rawJson,
      ),
    );
  } on Object {
    // The platform owns this isolate; never allow user callbacks to crash it.
  }
}
