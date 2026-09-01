/// The lifecycle context in which a notification event was observed.
enum NotificationState {
  /// The application UI is visible.
  foreground,

  /// The application is running but not visible.
  background,

  /// The application was launched from a notification.
  terminated,

  /// The application was resumed from a notification tap.
  resumed,

  /// The lifecycle could not be determined.
  unknown,
}

/// The operating system that produced an event.
enum NotificationPlatform {
  /// Android.
  android,

  /// iOS.
  ios,

  /// macOS.
  macos,

  /// Web.
  web,

  /// An unsupported or unknown host.
  unknown,
}

/// The kind of user interaction with a notification.
enum NotificationInteraction {
  /// The notification body was tapped.
  bodyTap,

  /// An action button was tapped.
  actionTap,

  /// The notification was dismissed.
  dismiss,

  /// An inline reply was submitted.
  reply,

  /// The application was launched from the notification.
  launch,
}

/// Android notification importance abstraction.
enum ChannelImportance {
  /// Highest interruption level.
  max,

  /// Heads-up notifications.
  high,

  /// Default interruption level.
  defaultImportance,

  /// Minimized interruption.
  low,

  /// No sound or vibration.
  silent,
}

/// Package log verbosity.
enum FcmLogLevel {
  /// Extra diagnostic detail.
  verbose,

  /// Development diagnostics.
  debug,

  /// Recoverable problems.
  warning,

  /// Failures that were swallowed or retried.
  error,

  /// Disable logging.
  silent,
}

/// Whether an action runs in the UI isolate, a background isolate, or either.
enum ActionExecutionMode {
  /// Requires the application UI.
  foreground,

  /// May run in a background isolate.
  background,

  /// Either isolate is acceptable.
  any,
}
