import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists recently processed action identities to suppress duplicate/replayed
/// platform callbacks across process restarts.
final class ReplayGuard {
  ReplayGuard({SharedPreferencesAsync? preferences, required this.window})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _storageKey = 'fcm_actions.processed.v1';

  final SharedPreferencesAsync _preferences;
  final Duration window;
  Future<void> _serial = Future<void>.value();

  Future<bool> claim(String identity, DateTime now) {
    late bool claimed;
    _serial = _serial.then((_) async {
      final entries = await _read();
      final cutoff = now.subtract(window);
      entries.removeWhere((_, value) => value.isBefore(cutoff));
      claimed = !entries.containsKey(identity);
      if (claimed) entries[identity] = now;
      await _write(entries);
    });
    return _serial.then((_) => claimed);
  }

  Future<Map<String, DateTime>> _read() async {
    final encoded = await _preferences.getString(_storageKey);
    if (encoded == null) return <String, DateTime>{};
    try {
      final value = jsonDecode(encoded);
      if (value is! Map) return <String, DateTime>{};
      return value.map<String, DateTime>(
        (key, timestamp) => MapEntry(
          key.toString(),
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(timestamp.toString()),
            isUtc: true,
          ),
        ),
      );
    } on Object {
      return <String, DateTime>{};
    }
  }

  Future<void> _write(Map<String, DateTime> entries) => _preferences.setString(
    _storageKey,
    jsonEncode(
      entries.map(
        (key, value) => MapEntry(key, value.toUtc().millisecondsSinceEpoch),
      ),
    ),
  );
}
