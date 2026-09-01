import 'dart:collection';

import '../core/exceptions.dart';
import '../models/configuration_models.dart';

/// In-memory Android channel registry.
final class ChannelRegistry {
  final Map<String, NotificationChannel> _channels =
      <String, NotificationChannel>{};

  /// Registered channels keyed by id.
  UnmodifiableMapView<String, NotificationChannel> get channels =>
      UnmodifiableMapView<String, NotificationChannel>(_channels);

  /// Adds or replaces a channel definition.
  void register(NotificationChannel channel) {
    if (channel.id.trim().isEmpty || channel.name.trim().isEmpty) {
      throw const InvalidNotificationPayloadException(
        'Channel id and name must not be empty.',
      );
    }
    _channels[channel.id] = channel;
  }

  /// Registers every channel in [channels].
  void registerAll(Iterable<NotificationChannel> channels) {
    for (final channel in channels) {
      register(channel);
    }
  }

  /// Returns the channel for [id], if registered.
  NotificationChannel? find(String id) => _channels[id];
}
