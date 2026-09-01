# Architecture

`fcm_actions` uses a static facade only for the common one-app experience. The
runtime itself is an owned, injectable object graph; registries, streams, and
platform adapters are not global singletons.

```mermaid
flowchart TD
    App[Application] --> Facade[FcmActions facade]
    App --> Client[FcmActionsClient]
    Facade --> Client
    Client --> Engine[NotificationEngine]

    Engine --> Parser[NotificationParser]
    Engine --> Actions[ActionRegistry]
    Engine --> Channels[ChannelRegistry]
    Engine --> Events[Typed Event Bus]
    Engine --> Navigator[NotificationNavigator]
    Engine --> Queue[Durable ActionQueue]
    Engine --> Replay[ReplayGuard]

    FCM[Firebase Messaging] --> MessagingGateway[MessagingGateway]
    MessagingGateway --> Engine
    Engine --> LocalGateway[LocalNotificationsGateway]
    LocalGateway --> Android[Android channels and actions]
    LocalGateway --> Apple[iOS and macOS categories]
    LocalGateway --> Web[Web notifications]
    Engine --> Token[FCM token and topics]

    FCM --> Background[Background dispatcher]
    Background --> Queue
    Background --> LocalGateway
    Background --> Callback[Top-level app callback]

    Engine --> Interceptors[Display and action interceptors]
    Engine --> Middleware[Middleware chain]
    Engine --> Analytics[Analytics adapters]
```

## Package layout

```text
lib/
  fcm_actions.dart
  fcm_actions_testing.dart
  src/
    actions/       action definitions and handlers
    channels/      channel registry
    core/          facade, client, engine, contracts, configuration
    handlers/      callback and object-oriented action handlers
    models/        Freezed/json_serializable immutable models
    navigation/    named-route mapping
    parser/        normalization and payload validation
    platform/      Firebase and local notification gateways
    services/      event bus, replay protection, durable retry queue
    utils/         narrowly scoped platform utilities
```

## Message flow

1. `MessagingGateway` receives an FCM message.
2. `NotificationParser` validates and normalizes notification, data, mixed,
   topic, condition, and silent payload shapes.
3. The engine emits a typed lifecycle event.
4. Non-silent foreground and data-only messages pass through display
   interceptors and the local notification gateway.
5. A tap/reply is normalized into `NotificationActionEvent`.
6. Replay protection claims the message/action identity.
7. Action interceptors and middleware run, followed by the registered handler
   and global callback.
8. Failures enter the bounded persistent retry queue.
9. Events and analytics adapters are notified without coupling them to action
   execution.

## Background isolates

Flutter background entry points cannot access main-isolate objects. The
dispatcher therefore persists only JSON-safe configuration, initializes
plugins in the isolate, invokes an optional top-level callback, and hands failed
or unhandled work back to the main isolate. Callback handles are validated at
initialization.

## Dependency injection

`NotificationEngine` accepts messaging and local-notification gateways, event
bus, registries, queue, and replay guard. Production defaults are provided, but
tests can replace every external boundary. `FcmActionsClient` owns and disposes
the engine; the facade merely delegates to one default client.
