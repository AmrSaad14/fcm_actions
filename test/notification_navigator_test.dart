import 'dart:async';

import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('maps payload types to named routes without a switch', (
    tester,
  ) async {
    final key = GlobalKey<NavigatorState>();
    final navigator = NotificationNavigator(
      navigatorKey: key,
      routes: const <RouteMapper>[RouteMapper(type: 'chat', route: '/chat')],
    );
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: const Text('home'),
        routes: <String, WidgetBuilder>{
          '/chat': (_) => const Scaffold(body: Text('chat screen')),
        },
      ),
    );

    unawaited(
      navigator.navigateMessage(
        const NotificationMessage(
          notificationId: 1,
          messageId: 'm1',
          routeType: 'chat',
          data: <String, Object?>{'conversation_id': 'c1'},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('chat screen'), findsOneWidget);
    expect(
      ModalRoute.of(
        tester.element(find.text('chat screen')),
      )!.settings.arguments,
      <String, Object?>{'conversation_id': 'c1'},
    );
  });
}
