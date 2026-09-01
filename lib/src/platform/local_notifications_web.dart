import '../models/configuration_models.dart';
import '../models/notification_message.dart';
import 'platform_gateways.dart';

/// Web local-notification adapter.
///
/// Browser / FCM service-worker display is used for remote notifications.
/// [show] is a no-op so this library never imports `dart:io` on web/WASM.
final class FlutterLocalNotificationsGateway
    implements LocalNotificationsGateway {
  FlutterLocalNotificationsGateway({Object? plugin});

  @override
  Future<PlatformNotificationResponse?> initialize({
    required String defaultAndroidIcon,
    required bool requestPermission,
    required List<NotificationMessage> categoryTemplates,
    required PlatformNotificationResponseCallback onResponse,
  }) async => null;

  @override
  Future<void> createChannels(Iterable<NotificationChannel> channels) async {}

  @override
  Future<void> registerCategories(
    Iterable<NotificationMessage> templates,
  ) async {}

  @override
  Future<void> show(
    NotificationMessage message,
    NotificationChannel channel,
  ) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}
