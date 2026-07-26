import 'package:fcm_actions/fcm_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notification actions serialize without losing custom metadata', () {
    const action = NotificationAction(
      id: 'download_invoice',
      title: 'Download',
      icon: 'download',
      metadata: <String, Object?>{'format': 'pdf'},
    );

    expect(NotificationAction.fromJson(action.toJson()), action);
  });
}
