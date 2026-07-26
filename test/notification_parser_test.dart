import 'package:fcm_actions/fcm_actions.dart';
import 'package:fcm_actions/fcm_actions_testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const registered = NotificationAction(id: 'accept', title: 'Accept');
  late NotificationParser parser;

  setUp(() {
    parser = NotificationParser(
      maxPayloadBytes: 4096,
      defaultChannelId: 'default',
      resolveAction: (id) => id == registered.id ? registered : null,
    );
  });

  test('parses JSON actions and registered action references', () {
    final message = parser.parseMap(<String, Object?>{
      'message_id': 'message-1',
      'notification_id': '42',
      'title': 'Invitation',
      'actions': '[{"id":"reply","title":"Reply","input":true},"accept"]',
      'type': 'chat',
    });

    expect(message.notificationId, 42);
    expect(message.channelId, 'default');
    expect(message.routeType, 'chat');
    expect(message.actions, hasLength(2));
    expect(message.actions.first.input, isTrue);
    expect(message.actions.last, registered);
    expect(message.categoryId, startsWith('fcm_actions_'));
  });

  test('generates a deterministic positive notification id', () {
    final first = parser.parseMap(<String, Object?>{'message_id': 'same'});
    final second = parser.parseMap(<String, Object?>{'message_id': 'same'});

    expect(first.notificationId, second.notificationId);
    expect(first.notificationId, isNonNegative);
  });

  test('rejects malformed and oversized payloads', () {
    expect(
      () => parser.parseMap(<String, Object?>{'actions': '{bad json'}),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );

    final tinyParser = NotificationParser(
      maxPayloadBytes: 8,
      defaultChannelId: 'default',
      resolveAction: (_) => null,
    );
    expect(
      () => tinyParser.parseMap(<String, Object?>{'body': 'too long'}),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );
  });

  test('rejects unknown id-only actions but permits dynamic definitions', () {
    expect(
      () => parser.parseMap(<String, Object?>{
        'actions': <Object?>['future_action'],
      }),
      throwsA(isA<InvalidNotificationPayloadException>()),
    );

    final message = parser.parseMap(<String, Object?>{
      'actions': <Object?>[
        <String, Object?>{'id': 'future_action', 'title': 'Anything'},
      ],
    });
    expect(message.actions.single.id, 'future_action');
  });
}
