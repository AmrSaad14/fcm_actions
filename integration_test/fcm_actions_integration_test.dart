import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initializes and displays through injected platform adapters', (
    tester,
  ) async {
    final messaging = FakeMessagingGateway();
    final notifications = FakeLocalNotificationsGateway();
    const config = FcmActionsConfig(
      initializeFirebase: false,
      requestPermission: false,
    );
    final engine = NotificationEngine(
      config: config,
      messaging: messaging,
      localNotifications: notifications,
    );
    final client = FcmActionsClient(config, engine: engine);

    await client.initialize();
    await client.show(
      client.parse(<String, Object?>{
        'message_id': 'integration-1',
        'title': 'Integration test',
      }),
    );

    expect(notifications.shown.single.messageId, 'integration-1');
    await client.dispose();
    await messaging.dispose();
  });
}
