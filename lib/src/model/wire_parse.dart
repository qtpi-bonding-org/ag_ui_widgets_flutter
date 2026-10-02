// lib/src/model/wire_parse.dart
// Tolerant JSON readers for wire payloads. They never throw: a value of the
// wrong type reads as null (or empty), so a malformed field cannot take the
// reducer down. Callers decide whether a null means "absent" or "malformed".

Map<String, dynamic>? asJsonMap(Object? v) =>
    v is Map ? Map<String, dynamic>.from(v) : null;

String? asString(Object? v) => v is String ? v : null;

int? asInt(Object? v) => v is num ? v.toInt() : null;

List<Map<String, dynamic>> asJsonMapList(Object? v) => v is List
    ? [
        for (final e in v)
          if (e is Map) Map<String, dynamic>.from(e),
      ]
    : const [];

/// Every entry of [m] whose key is not in [known] — what a model keeps in its
/// `extras` so an unknown wire field is retained, never discarded.
Map<String, dynamic> extrasOf(Map<String, dynamic> m, Set<String> known) => {
      for (final e in m.entries)
        if (!known.contains(e.key)) e.key: e.value,
    };
