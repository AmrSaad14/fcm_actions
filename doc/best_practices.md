# Best practices

## Payloads

- Send stable, globally unique `message_id` values.
- Keep `notification_id` stable when an update should replace a notification.
- Keep payloads small and JSON-safe.
- Prefer data messages when actions must be generated dynamically.
- Include both `title` and `body` in data messages that should be displayed.
- Treat all client payload fields as untrusted input.

## Actions

- Register terminated-state actions during initialization.
- Make handlers idempotent and enforce authorization on the server.
- Keep background handlers short; hand long-running work to a supported
  platform/background-work mechanism.
- Use `showsUserInterface: false` only for isolate-safe work.
- Use `input: true` for reply actions and expect `replyText` to be nullable.

## Lifecycle

- Initialize after `WidgetsFlutterBinding.ensureInitialized()` and before
  `runApp`.
- Use one package initialization per Firebase app.
- Do not add another Firebase background message handler.
- Test on physical iOS and Android devices; simulators do not reproduce all
  push and process-kill behavior.

## Channels and categories

- Version Android channel IDs when sound or importance changes.
- Keep channel names user-facing and localized by the application.
- Use a stable iOS category ID for OS-rendered remote notifications.
- Expect platform UI to limit visible buttons.

## Reliability

- Log message IDs and action IDs, but avoid personal payload content.
- Add analytics through adapters so telemetry failures cannot block actions.
- Tune `replayProtectionWindow` to the maximum valid action lifetime.
- Keep `maxActionRetries` low and add exponential backoff in network
  middleware when required.
- Explicitly call `retryPendingActions()` after connectivity/authentication is
  restored if resume-based retry is not soon enough.

## Testing

- Inject `MessagingGateway` and `LocalNotificationsGateway` fakes.
- Test malformed, duplicate, expired, and oversized payloads.
- Verify navigation with the real `Navigator` in widget tests.
- Run terminated/background scenarios on release builds because tree shaking
  and background isolate behavior differ from debug mode.
