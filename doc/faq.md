# FAQ

## Does this remove all native setup?

It removes application delegate/activity code. Firebase configuration files,
Apple signing capabilities, APNs credentials, and Android/iOS notification
resources are platform configuration and still belong to the application.

## Are actions unlimited?

The registry accepts any number of action definitions and arbitrary IDs.
Android and iOS decide how many buttons fit on one notification; iOS commonly
shows fewer than are registered.

## Why are actions missing from a terminated iOS notification?

The operating system rendered that remote notification before Dart ran. Send a
`category`/`category_id` registered during initialization. Fully dynamic action
sets are available when the package renders a local/data notification.

## Do topic and condition messages require another API?

Incoming topic and condition payloads are parsed through the same
notification/data/mixed path. To change which topics this device is subscribed
to, call `FcmActions.subscribeToTopic` / `unsubscribeFromTopic`. Those APIs are
not available on web.

## How do I get the FCM token?

`FcmActions.initialize` returns it on `FcmActionsInitResult.token`. Listen to
`FcmActions.onTokenRefresh` for rotations, or call `FcmActions.getToken()`. On
iOS and macOS the package waits for an APNs token first.

## Are killed and force-stopped apps guaranteed to receive data messages?

No. iOS background delivery is best-effort, and Android does not deliver to an
app the user force-stopped until it is opened again. No Flutter package can
override those operating-system policies.

## Can a background callback navigate or update UI?

No. It runs in a separate isolate. Persist work or use isolate-safe services;
navigation and widget state belong to main-isolate streams.

## Why did changing an Android channel do nothing?

Android makes importance, sound, and vibration immutable after channel
creation. Use a new channel ID or clear application data during development.

## How do I use Firebase Analytics or Mixpanel?

Implement `NotificationAnalytics` and pass the adapter in `analytics`. The core
package deliberately does not require either analytics SDK.

## How are offline actions retried?

Any action callback or middleware failure is persisted. The queue drains when
the app initializes/resumes or when `retryPendingActions()` is called. Handlers
must be idempotent because remote systems can succeed before a local timeout.

## Can I use multiple Firebase apps?

Create separate `FcmActionsClient` object graphs and supply
`FcmActionsConfig(firebaseAppName: ..., firebaseOptions: ...)`. The static
facade is intended for one default client.
