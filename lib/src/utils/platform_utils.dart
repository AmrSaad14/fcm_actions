import 'package:flutter/foundation.dart';

import '../models/enums.dart';

NotificationPlatform get currentNotificationPlatform {
  if (kIsWeb) return NotificationPlatform.unknown;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => NotificationPlatform.android,
    TargetPlatform.iOS => NotificationPlatform.ios,
    _ => NotificationPlatform.unknown,
  };
}
