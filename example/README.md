# fcm_actions example

The example demonstrates chat replies, incoming-call actions, order actions,
runtime custom actions, route mapping, deep links, background callbacks, silent
payloads, and local data-message fallback.

## Configure

1. Install FlutterFire CLI.
2. From this directory, run `flutterfire configure`.
3. Enable Push Notifications and Background Modes > Remote notifications for
   the iOS Runner target.
4. Run on a physical device with `flutter run`.

The UI can create local scenarios without a push server after Firebase
initialization succeeds.

## Data-only FCM payload

Send platform-specific priority/APNs headers appropriate to your server SDK.
The data body can use:

```json
{
  "message_id": "chat-100",
  "notification_id": "100",
  "title": "New message",
  "body": "Can you review this?",
  "type": "chat",
  "channel_id": "fcm_actions_high",
  "actions": "[{\"id\":\"reply\",\"title\":\"Reply\",\"input\":true,\"showsUserInterface\":false},{\"id\":\"archive\",\"title\":\"Archive\"}]"
}
```

## Call payload

```json
{
  "message_id": "call-200",
  "notification_id": "200",
  "title": "Incoming call",
  "body": "Taylor is calling",
  "type": "call",
  "channel_id": "fcm_actions_max",
  "actions": "[{\"id\":\"accept\",\"title\":\"Accept\"},{\"id\":\"decline\",\"title\":\"Decline\",\"destructive\":true}]"
}
```

To test terminated-state iOS actions, register the corresponding category
during initialization and send its category in the APNs payload. Dynamic action
sets sent only in FCM data cannot be read by Dart before an OS-rendered remote
notification appears.
# fcm_actions_example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
