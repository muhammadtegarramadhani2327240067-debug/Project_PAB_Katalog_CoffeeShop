import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _idsKey = "favorite_ids";
  static const String _boolPrefix = "favorite_";
  static const String _itemPrefix = "favorite_item_";

  static final ValueNotifier<int> count = ValueNotifier<int>(0);
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static Future<void> _syncCount(SharedPreferences prefs) async {
    final ids = prefs.getStringList(_idsKey) ?? const <String>[];
    count.value = ids.length;
  }

  static Future<List<String>> _getIds(SharedPreferences prefs) async {
    return List<String>.from(prefs.getStringList(_idsKey) ?? const <String>[]);
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final ids = prefs.getStringList(_idsKey);
    if (ids != null) return ids.contains(id);

    return prefs.getBool("$_boolPrefix$id") ?? false;
  }

  static Future<void> setFavorite({
    required String id,
    required Map<String, dynamic> item,
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await _getIds(prefs);
    final exists = ids.contains(id);

    if (value && !exists) {
      ids.add(id);
      await prefs.setStringList(_idsKey, ids);
      await prefs.setString("$_itemPrefix$id", jsonEncode(item));
      await prefs.setBool("$_boolPrefix$id", true);
    } else if (!value && exists) {
      ids.remove(id);
      await prefs.setStringList(_idsKey, ids);
      await prefs.remove("$_itemPrefix$id");
      await prefs.setBool("$_boolPrefix$id", false);
    } else {
      await prefs.setBool("$_boolPrefix$id", value);
      if (value) {
        await prefs.setString("$_itemPrefix$id", jsonEncode(item));
      }
    }

    await _syncCount(prefs);
    revision.value++;
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_idsKey) ?? const <String>[];

    final out = <Map<String, dynamic>>[];
    for (final id in ids) {
      final raw = prefs.getString("$_itemPrefix$id");
      if (raw == null || raw.isEmpty) continue;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) out.add(decoded.cast<String, dynamic>());
      } catch (_) {}
    }
    return out;
  }

  static Future<int> refreshCount() async {
    final prefs = await SharedPreferences.getInstance();
    await _syncCount(prefs);
    return count.value;
  }

  static void resetForSignedOut() {
    count.value = 0;
    revision.value++;
  }
}
