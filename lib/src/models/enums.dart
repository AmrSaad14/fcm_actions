/// The lifecycle context in which a notification event was observed.
enum NotificationState { foreground, background, terminated, resumed, unknown }

/// The operating system that produced an event.
enum NotificationPlatform { android, ios, unknown }

/// The kind of user interaction with a notification.
enum NotificationInteraction { bodyTap, actionTap, dismiss, reply, launch }

/// Android notification importance abstraction.
enum ChannelImportance { max, high, defaultImportance, low, silent }

/// Package log verbosity.
enum FcmLogLevel { verbose, debug, warning, error, silent }

/// Whether an action runs in the UI isolate, a background isolate, or either.
enum ActionExecutionMode { foreground, background, any }
