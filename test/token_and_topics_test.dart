import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/src/platform/firebase_messaging_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rejects invalid FCM topic names before calling Firebase', () {
    expect(
      () => FirebaseMessagingGateway.validateTopic('bad topic'),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
    expect(
      () => FirebaseMessagingGateway.validateTopic(''),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
    FirebaseMessagingGateway.validateTopic('orders');
  });

  test('permission granted covers authorized and provisional', () {
    expect(
      const NotificationPermission(
        status: NotificationAuthorization.authorized,
      ).granted,
      isTrue,
    );
    expect(
      const NotificationPermission(
        status: NotificationAuthorization.provisional,
      ).granted,
      isTrue,
    );
    expect(NotificationPermission.undetermined.granted, isFalse);
  });

  test('silent logger discards messages', () {
    const SilentFcmActionsLogger().log(FcmLogLevel.error, 'ignored');
  });
}
