import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/fcm_actions_config.dart';
import '../models/configuration_models.dart';
import '../models/events.dart';
import '../models/notification_action.dart';

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

  /// Persists a background notification for the main isolate.
  static Future<void> appendPendingNotification(NotificationEvent event) async {
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

  /// Persists a background action for the main isolate.
  static Future<void> appendPendingAction(NotificationActionEvent event) async {
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

  /// Reads isolate-safe configuration persisted by [configure].
  static Future<Map<String, Object?>?> readConfiguration() async {
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

  /// Restores [FirebaseOptions] persisted for a background isolate.
  static FirebaseOptions firebaseOptionsFromJson(Map<String, Object?> json) =>
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
