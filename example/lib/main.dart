import 'dart:async';

import 'package:fcm_actions/fcm_actions.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final eventLog = ValueNotifier<List<String>>(<String>[]);

const replyAction = NotificationAction(
  id: 'reply',
  title: 'Reply',
  input: true,
  inputLabel: 'Type a reply',
  showsUserInterface: false,
  executionMode: ActionExecutionMode.background,
);
const acceptAction = NotificationAction(id: 'accept', title: 'Accept');
const declineAction = NotificationAction(
  id: 'decline',
  title: 'Decline',
  destructive: true,
);
const archiveAction = NotificationAction(id: 'archive', title: 'Archive');

@pragma('vm:entry-point')
Future<void> backgroundActionHandler(NotificationActionEvent event) async {
  debugPrint('Background action: ${event.actionId}, reply: ${event.replyText}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? initializationError;
  try {
    await FcmActions.initialize(
      navigatorKey: navigatorKey,
      actions: const <NotificationAction>[
        replyAction,
        acceptAction,
        declineAction,
      ],
      routes: const <RouteMapper>[
        RouteMapper(type: 'chat', route: '/chat'),
        RouteMapper(type: 'call', route: '/call'),
        RouteMapper(type: 'order', route: '/order'),
      ],
      backgroundActionHandler: backgroundActionHandler,
      onAction: (event, data) async =>
          _log('action=${event.actionId} reply=${event.replyText ?? '-'}'),
    );
    FcmActions.registerAction(
      archiveAction,
      handler: (event) async => _log('Archived ${event.message.messageId}'),
    );
    FcmActions.onNotification.listen(
      (event) => _log(
        '${event.state.name}: ${event.message.title ?? 'silent message'}',
      ),
    );
    FcmActions.onDismiss.listen(
      (event) => _log('dismissed=${event.message.notificationId}'),
    );
    FcmActions.onReply.listen((event) => _log('reply=${event.replyText}'));
  } on Object catch (error) {
    // Run `flutterfire configure` before launching this example.
    initializationError = error;
  }
  runApp(DemoApp(initializationError: initializationError));
}

void _log(String value) {
  eventLog.value = <String>[
    '${DateTime.now().toIso8601String()}  $value',
    ...eventLog.value.take(19),
  ];
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key, this.initializationError});

  final Object? initializationError;

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    title: 'fcm_actions example',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    routes: <String, WidgetBuilder>{
      '/chat': (_) => const DetailScreen(title: 'Chat'),
      '/call': (_) => const DetailScreen(title: 'Call'),
      '/order': (_) => const DetailScreen(title: 'Order'),
      '/deep-link/invoice': (_) =>
          const DetailScreen(title: 'Deep-linked invoice'),
    },
    home: DemoHome(initializationError: initializationError),
  );
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key, this.initializationError});

  final Object? initializationError;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('fcm_actions scenarios')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (initializationError != null)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Firebase is not configured. Run `flutterfire configure` '
                'for the example app.\n\n$initializationError',
              ),
            ),
          ),
        _ScenarioButton(
          label: 'Chat with inline reply',
          onPressed: () => _show(
            title: 'New message from Sam',
            body: 'Are we still meeting at 3?',
            type: 'chat',
            actions: const <NotificationAction>[replyAction, archiveAction],
          ),
        ),
        _ScenarioButton(
          label: 'Incoming call (accept / decline)',
          onPressed: () => _show(
            title: 'Incoming call',
            body: 'Taylor is calling',
            type: 'call',
            channelId: NotificationChannel.max.id,
            actions: const <NotificationAction>[acceptAction, declineAction],
          ),
        ),
        _ScenarioButton(
          label: 'Order with dynamic action',
          onPressed: () => _show(
            title: 'Order shipped',
            body: 'Order #1042 is on its way',
            type: 'order',
            actions: const <NotificationAction>[
              NotificationAction(id: 'track_order', title: 'Track'),
            ],
          ),
        ),
        _ScenarioButton(
          label: 'Deep link',
          onPressed: () => _show(
            title: 'Invoice ready',
            body: 'Tap to view invoice',
            deepLink: '/deep-link/invoice',
          ),
        ),
        _ScenarioButton(
          label: 'Local data-message fallback',
          onPressed: () => _show(
            title: 'Locally rendered',
            body: 'This uses the FCM data-message display path.',
          ),
        ),
        _ScenarioButton(
          label: 'Silent notification',
          onPressed: () async {
            if (!FcmActions.isInitialized) return;
            final message = FcmActions.parse(<String, Object?>{
              'message_id': 'silent-demo',
              'silent': true,
              'type': 'sync',
            });
            _log('silent payload parsed: ${message.messageId}');
          },
        ),
        const SizedBox(height: 24),
        Text('Events', style: Theme.of(context).textTheme.titleLarge),
        ValueListenableBuilder<List<String>>(
          valueListenable: eventLog,
          builder: (context, values, _) => SelectableText(
            values.isEmpty ? 'No events yet.' : values.join('\n'),
          ),
        ),
      ],
    ),
  );

  static Future<void> _show({
    String? title,
    String? body,
    String? type,
    String? deepLink,
    String? channelId,
    List<NotificationAction> actions = const <NotificationAction>[],
  }) async {
    if (!FcmActions.isInitialized) return;
    await FcmActions.show(
      title: title,
      body: body,
      routeType: type,
      deepLink: deepLink,
      channelId: channelId,
      actions: actions,
      data: <String, Object?>{
        'demo': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }
}

class _ScenarioButton extends StatelessWidget {
  const _ScenarioButton({required this.label, required this.onPressed});

  final String label;
  final FutureOr<void> Function() onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: FilledButton.tonal(
      onPressed: () => onPressed(),
      child: Align(alignment: Alignment.centerLeft, child: Text(label)),
    ),
  );
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: SelectableText(
        'Route arguments:\n'
        '${ModalRoute.of(context)?.settings.arguments ?? const {}}',
      ),
    ),
  );
}
