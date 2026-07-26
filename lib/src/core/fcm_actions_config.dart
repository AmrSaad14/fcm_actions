import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../models/configuration_models.dart';
import '../models/notification_action.dart';
import 'contracts.dart';

/// Immutable initialization options for [FcmActionsClient].
final class FcmActionsConfig {
  const FcmActionsConfig({
    this.navigatorKey,
    this.firebaseOptions,
    this.firebaseAppName,
    this.initializeFirebase = true,
    this.requestPermission = true,
    this.autoDisplayDataMessages = true,
    this.autoNavigate = true,
    this.defaultAndroidIcon = '@mipmap/ic_launcher',
    this.defaultChannelId = 'fcm_actions_default',
    this.actions = const <NotificationAction>[],
    this.channels = const <NotificationChannel>[
      NotificationChannel.max,
      NotificationChannel.high,
      NotificationChannel.defaultChannel,
      NotificationChannel.low,
      NotificationChannel.silent,
    ],
    this.routes = const <RouteMapper>[],
    this.onAction,
    this.onNotification,
    this.backgroundActionHandler,
    this.interceptors = const <NotificationInterceptor>[],
    this.actionInterceptors = const <ActionInterceptor>[],
    this.middleware = const <NotificationMiddleware>[],
    this.analytics = const <NotificationAnalytics>[],
    this.logger = const DebugFcmActionsLogger(),
    this.replayProtectionWindow = const Duration(days: 7),
    this.maxPayloadBytes = 32768,
    this.queueFailedActions = true,
    this.maxActionRetries = 3,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final FirebaseOptions? firebaseOptions;
  final String? firebaseAppName;
  final bool initializeFirebase;
  final bool requestPermission;
  final bool autoDisplayDataMessages;
  final bool autoNavigate;
  final String defaultAndroidIcon;
  final String defaultChannelId;
  final List<NotificationAction> actions;
  final List<NotificationChannel> channels;
  final List<RouteMapper> routes;
  final FcmActionsInitializeCallback? onAction;
  final NotificationEventCallback? onNotification;

  /// Must be a top-level or static function so Flutter can invoke it in a
  /// background isolate.
  final NotificationActionCallback? backgroundActionHandler;

  final List<NotificationInterceptor> interceptors;
  final List<ActionInterceptor> actionInterceptors;
  final List<NotificationMiddleware> middleware;
  final List<NotificationAnalytics> analytics;
  final FcmActionsLogger logger;
  final Duration replayProtectionWindow;
  final int maxPayloadBytes;
  final bool queueFailedActions;
  final int maxActionRetries;
}
