## 1.0.2

- Raised minimum supported `firebase_core` to `^5.0.0` and `firebase_messaging`
  to `^17.0.0` so pub.dev dependency scoring stays current.

## 1.0.1

- Restored full pub.dev platform points by keeping `flutter_local_notifications`
  (and its Windows `dart:io` import) behind IO-only conditional imports so the
  declared web target is WASM-compatible.

## 1.0.0

- Marked the package stable after the 0.1 preview.
- Added FCM token APIs: `getToken`, `onTokenRefresh`, `deleteToken`, and
  `getAPNSToken`, with Apple APNs-ready retries before token fetch.
- Added topic `subscribeToTopic` / `unsubscribeFromTopic` with FCM name
  validation.
- `initialize` now returns `FcmActionsInitResult` with permission, token, and
  platform support instead of discarding permission status.
- Added `NotificationPermission`, `NotificationPermissionRequest`,
  `getPermissionStatus`, and `SilentFcmActionsLogger`.
- Declared macOS and web support, including Darwin/web local notification
  settings and a web-safe background-handler registration.
- Added `unregisterAction` and Dependabot so dependencies stay current.

## 0.1.2

- Bumped package version and changelog for a clean pub.dev republish.

## 0.1.1

- Fixed package repository metadata for pub.dev verification.

## 0.1.0

- Initial preview release.
- Added foreground, background, opened-app, and terminated-state FCM handling.
- Added dynamic Android/iOS actions, Android inline reply, channels, and iOS
  categories.
- Added typed event streams, route mapping, middleware, interceptors, and
  analytics adapters.
- Added durable retries, replay protection, payload validation, and
  isolate-safe background callbacks.
- Added an injectable API, complete example, unit/widget/integration tests, and
  publication documentation.
