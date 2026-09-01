# Migration guide

## From 0.1.x

`1.0.0` is API-compatible for existing `initialize` callers. New optional
arguments and a returned `FcmActionsInitResult` can be ignored. Replace any
direct `FirebaseMessaging.instance.getToken` / `subscribeToTopic` usage with
the matching `FcmActions` methods so Apple APNs readiness and topic validation
stay in one place.

`NotificationPlatform` now includes `macos` and `web`. Update exhaustive
switches.

## From direct Firebase Messaging usage

Keep Firebase project files and server payloads. Remove application listeners
for `FirebaseMessaging.onMessage`, `onMessageOpenedApp`, and
`getInitialMessage`, then initialize `FcmActions` once before `runApp`.

Move:

- foreground display code to display interceptors;
- tap switch statements to `RouteMapper`;
- action switch statements to `registerAction(..., handler: ...)`;
- analytics calls to a `NotificationAnalytics` adapter;
- background work to a top-level `backgroundActionHandler`.

Do not also register `FirebaseMessaging.onBackgroundMessage`; Firebase
Messaging supports one application background handler and `fcm_actions`
registers it.

## From flutter_local_notifications

Keep custom Android sound/icon resources. Replace direct `show`, `cancel`, and
`cancelAll` calls with the matching `FcmActions` methods. Convert:

- `AndroidNotificationAction` or `DarwinNotificationAction` to
  `NotificationAction`;
- `AndroidNotificationChannel` to `NotificationChannel`;
- Darwin categories to registered action lists;
- notification response callbacks to `onAction`, `onReply`, and `onDismiss`.

Scheduled notifications are intentionally outside this package's FCM-action
scope. Continue using `flutter_local_notifications` directly for scheduling.

## Payload migration

Existing data remains available in `event.payload`. Add stable `message_id` and
`notification_id` values for reliable replay protection and cancellation. Move
application-specific action fields into:

```json
{
  "actions": [
    {"id": "archive", "title": "Archive"}
  ]
}
```

FCM data values can encode the entire `actions` array as a JSON string.

## Rollout

1. Register routes and actions while keeping old server payloads.
2. Send data-only test messages to internal devices.
3. Verify foreground, background, terminated, reply, and dismiss paths.
4. Update server payloads with action definitions/category IDs.
5. Remove old listeners only after observing one release without duplicates.
