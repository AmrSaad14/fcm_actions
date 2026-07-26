import 'dart:collection';

import '../core/exceptions.dart';
import '../models/configuration_models.dart';

final class ChannelRegistry {
  final Map<String, NotificationChannel> _channels =
      <String, NotificationChannel>{};

  UnmodifiableMapView<String, NotificationChannel> get channels =>
      UnmodifiableMapView<String, NotificationChannel>(_channels);

  void register(NotificationChannel channel) {
    if (channel.id.trim().isEmpty || channel.name.trim().isEmpty) {
      throw const InvalidNotificationPayloadException(
        'Channel id and name must not be empty.',
      );
    }
    _channels[channel.id] = channel;
  }

  void registerAll(Iterable<NotificationChannel> channels) {
    for (final channel in channels) {
      register(channel);
    }
  }

  NotificationChannel? find(String id) => _channels[id];
}
