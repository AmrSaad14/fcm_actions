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
  /// Creates a logger that prints at or above [minimumLevel].
  const DebugFcmActionsLogger({this.minimumLevel = FcmLogLevel.debug});

  /// Lowest level that will be printed.
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

/// Logger that discards every message.
final class SilentFcmActionsLogger implements FcmActionsLogger {
  /// Creates a no-op logger.
  const SilentFcmActionsLogger();

  @override
  void log(
    FcmLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}
}

/// Runs around notification display.
abstract interface class NotificationInterceptor {
  /// Return `null` to cancel display, or a (possibly rewritten) message.
  Future<NotificationMessage?> beforeDisplay(NotificationMessage message);

  /// Called after the local notification is shown.
  Future<void> afterDisplay(NotificationMessage message);
}

/// Runs around action execution. Returning `null` cancels the action.
abstract interface class ActionInterceptor {
  /// Return `null` to cancel execution, or a (possibly rewritten) event.
  Future<NotificationActionEvent?> beforeAction(NotificationActionEvent event);

  /// Called after the action handler and middleware complete.
  Future<void> afterAction(NotificationActionEvent event);
}

/// Composable action processing stage.
abstract interface class NotificationMiddleware {
  /// Invoke [next] to continue the chain, or return early to stop it.
  Future<void> handle(
    NotificationActionEvent event,
    Future<void> Function(NotificationActionEvent event) next,
  );
}

/// Optional analytics adapter (Firebase Analytics, Mixpanel, or custom).
abstract interface class NotificationAnalytics {
  /// A notification payload was received from FCM or a local callback.
  Future<void> notificationReceived(NotificationEvent event);

  /// A local notification was shown.
  Future<void> notificationDisplayed(NotificationEvent event);

  /// An action or inline reply completed.
  Future<void> actionExecuted(NotificationActionEvent event);

  /// The user dismissed a notification.
  Future<void> notificationDismissed(NotificationEvent event);
}
