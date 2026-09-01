import 'package:flutter/foundation.dart';

import '../models/enums.dart';

NotificationPlatform get currentNotificationPlatform {
  if (kIsWeb) return NotificationPlatform.web;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => NotificationPlatform.android,
    TargetPlatform.iOS => NotificationPlatform.ios,
    TargetPlatform.macOS => NotificationPlatform.macos,
    _ => NotificationPlatform.unknown,
  };
}
