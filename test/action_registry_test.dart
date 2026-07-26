import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registers and replaces extensible actions', () {
    final registry = ActionRegistry()
      ..register(const NotificationAction(id: 'share', title: 'Share'))
      ..register(const NotificationAction(id: 'share', title: 'Send'));

    expect(registry.find('share')?.title, 'Send');
    expect(registry.actions, hasLength(1));
  });

  test('keeps per-action handlers independent of definitions', () async {
    final registry = ActionRegistry();
    var called = false;
    registry.registerHandler('archive', (_) async => called = true);

    final message = NotificationMessage(notificationId: 1, messageId: 'm1');
    await registry.handlerFor('archive')!(
      NotificationActionEvent(
        actionId: 'archive',
        notificationId: 1,
        timestamp: DateTime.utc(2026),
        message: message,
        platform: NotificationPlatform.android,
        state: NotificationState.foreground,
      ),
    );
    expect(called, isTrue);
  });

  test('validates action ids and titles', () {
    final registry = ActionRegistry();
    expect(
      () => registry.register(
        const NotificationAction(id: '../unsafe', title: 'Unsafe'),
      ),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
    expect(
      () =>
          registry.register(const NotificationAction(id: 'valid', title: ' ')),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
  });
}
