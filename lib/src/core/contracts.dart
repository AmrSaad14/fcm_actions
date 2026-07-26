import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/events.dart';
import '../models/notification_message.dart';

typedef NotificationActionCallback =
    Future<void> Function(NotificationActionEvent event);
typedef FcmActionsInitializeCallback =
    FutureOr<void> Function(
      NotificationActionEvent action,
      Map<String, Object?> data,
    );
typedef NotificationEventCallback =
    Future<void> Function(NotificationEvent event);

/// Receives package diagnostics. Implementations must not throw.
abstract interface class FcmActionsLogger {
  void log(
    FcmLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Default logger that uses [debugPrint] and suppresses verbose release logs.
final class DebugFcmActionsLogger implements FcmActionsLogger {
  const DebugFcmActionsLogger({this.minimumLevel = FcmLogLevel.debug});

  final FcmLogLevel minimumLevel;

  @override
  void log(
    FcmLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (minimumLevel == FcmLogLevel.silent ||
        level.index < minimumLevel.index) {
      return;
    }
    debugPrint('[fcm_actions][${level.name}] $message');
    if (error != null) debugPrint('  $error');
    if (stackTrace != null && kDebugMode) debugPrint('$stackTrace');
  }
}

/// Runs around notification display.
abstract interface class NotificationInterceptor {
  Future<NotificationMessage?> beforeDisplay(NotificationMessage message);

  Future<void> afterDisplay(NotificationMessage message);
}

/// Runs around action execution. Returning `null` cancels the action.
abstract interface class ActionInterceptor {
  Future<NotificationActionEvent?> beforeAction(NotificationActionEvent event);

  Future<void> afterAction(NotificationActionEvent event);
}

/// Composable action processing stage.
abstract interface class NotificationMiddleware {
  Future<void> handle(
    NotificationActionEvent event,
    Future<void> Function(NotificationActionEvent event) next,
  );
}

/// Optional analytics adapter (Firebase Analytics, Mixpanel, or custom).
abstract interface class NotificationAnalytics {
  Future<void> notificationReceived(NotificationEvent event);

  Future<void> notificationDisplayed(NotificationEvent event);

  Future<void> actionExecuted(NotificationActionEvent event);

  Future<void> notificationDismissed(NotificationEvent event);
}
