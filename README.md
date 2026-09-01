# fcm_actions

Production-ready notification actions, tokens, topics, and routing for Firebase
Cloud Messaging on Android, iOS, macOS, and web.

`fcm_actions` normalizes FCM payloads, renders data messages, registers Android
channels and Apple categories, routes taps, handles inline replies, manages the
FCM token, and exposes typed event streams. Action IDs remain strings by design,
so applications can add actions without modifying this package.

## Requirements

- Flutter 3.41 or newer
- Dart 3.11 or newer
- Android, iOS, macOS, or web
- A Firebase project configured for the consuming application

## Installation

```yaml
dependencies:
  fcm_actions: ^1.0.0
```

Run `flutterfire configure` in the application. On iOS, enable the **Push
Notifications** capability and **Background Modes > Remote notifications** in
Xcode. Those signing entitlements cannot be added by a Dart package; no
application delegate or other native source code is required.

`flutter_local_notifications` requires Java core-library desugaring. In
`android/app/build.gradle.kts`, enable it in `compileOptions` and add its
dependency:

```kotlin
compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

## Quick start

```dart
final navigatorKey = GlobalKey<NavigatorState>();

final result = await FcmActions.initialize(
  navigatorKey: navigatorKey,
  actions: const [
    NotificationAction(id: 'accept', title: 'Accept'),
    NotificationAction(id: 'decline', title: 'Decline', destructive: true),
  ],
  routes: const [
    RouteMapper(type: 'chat', route: '/chat'),
  ],
  onAction: (event, data) async {
    debugPrint('${event.actionId}: $data');
  },
);

if (result.token != null) {
  await api.registerDeviceToken(result.token!);
}

FcmActions.onTokenRefresh.listen(api.registerDeviceToken);

runApp(MaterialApp(navigatorKey: navigatorKey));
```

## Tokens and topics

```dart
final token = await FcmActions.getToken();
final permission = await FcmActions.getPermissionStatus();

await FcmActions.subscribeToTopic('orders');
await FcmActions.unsubscribeFromTopic('orders');
```

On Apple platforms the package waits for an APNs token before calling
`getToken`. On web, pass `vapidKey` to `initialize` or `getToken`. Topics are
not supported on web. `initialize` also returns `permission`, `apnsToken`, and
`supported`. Use `SilentFcmActionsLogger` when you do not want debug output.

Actions can also be registered at runtime:

```dart
FcmActions.registerAction(
  const NotificationAction(
    id: 'download_invoice',
    title: 'Download',
    icon: 'download',
  ),
  handler: (event) async {
    await invoices.download(event.payload['invoice_id'] as String);
  },
);
```

## Payload format

`actions` may be a JSON array or a JSON-encoded string because FCM data values
are commonly strings.

```json
{
  "message_id": "invite-923",
  "notification_id": 923,
  "title": "Invitation",
  "body": "Join the project?",
  "type": "chat",
  "channel_id": "fcm_actions_high",
  "actions": [
    {"id": "accept", "title": "Accept"},
    {"id": "decline", "title": "Decline", "destructive": true},
    {
      "id": "reply",
      "title": "Reply",
      "input": true,
      "inputLabel": "Type a reply",
      "showsUserInterface": false
    }
  ]
}
```

An action object is fully dynamic. An ID-only entry such as `"accept"` resolves
an action previously registered by the application.

## Events

```dart
FcmActions.onNotification.listen((event) {});
FcmActions.onAction.listen((event) {});
FcmActions.onDismiss.listen((event) {});
FcmActions.onReply.listen((event) => debugPrint(event.replyText));
FcmActions.onForegroundMessage.listen((event) {});
FcmActions.onBackgroundMessage.listen((event) {});
FcmActions.onOpenedApp.listen((event) {});
FcmActions.onTokenRefresh.listen((token) {});
```

`NotificationActionEvent` includes the action ID, normalized payload,
notification and message IDs, timestamp, raw JSON, platform, lifecycle state,
reply text, and the complete `NotificationMessage`.

## Background actions and replies

An Android background callback must be a top-level or static entry point:

```dart
@pragma('vm:entry-point')
Future<void> notificationActionBackground(
  NotificationActionEvent event,
) async {
  // Use isolate-safe services only.
}

await FcmActions.initialize(
  backgroundActionHandler: notificationActionBackground,
);
```

If the callback fails or is omitted, the event is persisted and delivered to
the main isolate when the app resumes. Failed main-isolate actions are queued
and retried on resume, up to `maxActionRetries`.

iOS actions intentionally use Apple's foreground option so consuming apps do
not need AppDelegate plugin-registration code. They still work from background
and terminated notifications, but iOS launches the application UI to deliver
them.

## Local notifications

Foreground FCM notifications and non-silent data messages are rendered through
`flutter_local_notifications`, ensuring one action path:

```dart
await FcmActions.show(
  title: 'Invoice ready',
  body: 'Tap to view',
  deepLink: '/invoices/42',
  actions: const [
    NotificationAction(id: 'download', title: 'Download'),
  ],
);

await FcmActions.cancel(42);
await FcmActions.cancelAll();
```

Use `autoDisplayDataMessages: false` when the application wants to render
data-only foreground messages itself.

## Channels

Built-in Android channels are `NotificationChannel.max`, `.high`,
`.defaultChannel`, `.low`, and `.silent`. Add a custom channel before using it:

```dart
await FcmActions.registerChannel(
  const NotificationChannel(
    id: 'orders',
    name: 'Orders',
    description: 'Order status updates',
    importance: ChannelImportance.high,
  ),
);
```

Android channel sound and importance cannot be changed after creation. Use a
new channel ID when those settings change.

## Routing and deep links

`RouteMapper` removes application switch statements. The complete payload is
passed as named-route arguments. A `deep_link` payload value is treated as a
named route when no type mapping matches.

```dart
FcmActions.registerRoute(
  const RouteMapper(type: 'order', route: '/orders/detail'),
);
```

## Middleware and interceptors

Middleware composes authentication, logging, analytics, and permission checks.
Calling `next(event)` continues the chain.

```dart
final class AuthMiddleware implements NotificationMiddleware {
  @override
  Future<void> handle(
    NotificationActionEvent event,
    Future<void> Function(NotificationActionEvent event) next,
  ) async {
    if (session.isSignedIn) await next(event);
  }
}
```

Use `NotificationInterceptor` around display, `ActionInterceptor` around
execution, and `NotificationAnalytics` to adapt Firebase Analytics, Mixpanel,
or another provider. Adapter failures are logged and never crash the app.

## Security

- Payload size is limited to 32 KiB by default.
- Action IDs are validated and malformed JSON is rejected.
- Processed action/message identities persist for seven days to prevent
  duplicate execution and replay.
- Internal persistence uses bounded queues.
- Client payloads are untrusted. Authorize every action on the server; never
  embed a signing secret in a mobile application.

## Platform behavior

Dynamic actions work immediately for local notifications and FCM data messages.
An OS-rendered remote notification received while the app is terminated can
only use actions/categories known to the operating system before delivery.
Register those actions during initialization and send the matching
`category_id` on iOS. iOS may display fewer actions than supplied based on
available UI space.

FCM topic and condition messages need no client-specific handling; they arrive
as notification, data, or mixed messages. iOS silent delivery is best-effort
and requires `content-available: 1` plus the Background Modes entitlement.
Force-stopped Android apps and user-terminated iOS apps remain subject to OS
delivery restrictions.

## Testable API

The static facade owns one default client. For tests or multiple Firebase apps,
construct `FcmActionsClient` and inject a `NotificationEngine`. Platform seams
and fakes are exported from `package:fcm_actions/fcm_actions_testing.dart`.

See the complete [example](example/lib/main.dart), [architecture](doc/architecture.md),
[best practices](doc/best_practices.md), [FAQ](doc/faq.md), and
[migration guide](doc/migration.md).
