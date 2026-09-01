import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../models/configuration_models.dart';
import '../models/notification_action.dart';
import '../models/notification_permission.dart';
import 'contracts.dart';

/// Immutable initialization options for [FcmActionsClient].
final class FcmActionsConfig {
  /// Creates initialization options.
  const FcmActionsConfig({
    this.navigatorKey,
    this.firebaseOptions,
    this.firebaseAppName,
    this.initializeFirebase = true,
    this.requestPermission = true,
    this.permissionRequest = const NotificationPermissionRequest(),
    this.autoDisplayDataMessages = true,
    this.autoNavigate = true,
    this.fetchTokenOnInitialize = true,
    this.vapidKey,
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

  /// Optional navigator used for named-route mapping.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Firebase options when this package should initialize Firebase.
  final FirebaseOptions? firebaseOptions;

  /// Named Firebase app. `null` uses the default app.
  final String? firebaseAppName;

  /// Whether to call `Firebase.initializeApp` when no app exists.
  final bool initializeFirebase;

  /// Whether to prompt for notification permission during initialize.
  final bool requestPermission;

  /// Permission flags forwarded to the platform prompt.
  final NotificationPermissionRequest permissionRequest;

  /// Whether data-only foreground messages are rendered locally.
  final bool autoDisplayDataMessages;

  /// Whether notification taps navigate via [RouteMapper] / `deep_link`.
  final bool autoNavigate;

  /// Whether to fetch the FCM token during initialize.
  final bool fetchTokenOnInitialize;

  /// Web Push VAPID key required by `getToken` on web.
  final String? vapidKey;

  /// Android small-icon resource used by local notifications.
  final String defaultAndroidIcon;

  /// Fallback Android channel id.
  final String defaultChannelId;

  /// Actions registered before the first notification arrives.
  final List<NotificationAction> actions;

  /// Android channels created during initialize.
  final List<NotificationChannel> channels;

  /// Payload `type` to named-route mappings.
  final List<RouteMapper> routes;

  /// Global action callback. Receives the event and normalized payload.
  final FcmActionsInitializeCallback? onAction;

  /// Called for every received notification event.
  final NotificationEventCallback? onNotification;

  /// Must be a top-level or static function so Flutter can invoke it in a
  /// background isolate.
  final NotificationActionCallback? backgroundActionHandler;

  /// Runs around local notification display.
  final List<NotificationInterceptor> interceptors;

  /// Runs around action execution.
  final List<ActionInterceptor> actionInterceptors;

  /// Composable action pipeline.
  final List<NotificationMiddleware> middleware;

  /// Optional analytics adapters. Failures are logged, never thrown.
  final List<NotificationAnalytics> analytics;

  /// Diagnostic logger.
  final FcmActionsLogger logger;

  /// How long processed action/message identities are remembered.
  final Duration replayProtectionWindow;

  /// Maximum accepted payload size in bytes.
  final int maxPayloadBytes;

  /// Whether failed actions are persisted and retried.
  final bool queueFailedActions;

  /// Maximum drain attempts for a queued action.
  final int maxActionRetries;
}
