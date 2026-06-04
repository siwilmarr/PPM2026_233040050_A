import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _key = 'catatan_list';

  // ── Baca semua dari SharedPreferences ─────────────────────────────────────

  Future<List<Catatan>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final list = raw
        .map((s) => Catatan.fromMap(jsonDecode(s) as Map<String, Object?>))
        .toList();
    // Urutkan terbaru dulu
    list.sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
    return list;
  }

  // ── Simpan seluruh list ke SharedPreferences ───────────────────────────────

  Future<void> _saveAll(List<Catatan> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = list.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_key, raw);
  }

  // ── INSERT ─────────────────────────────────────────────────────────────────

  Future<void> insert(Catatan c) async {
    final list = await getAll();
    // Generate id: ambil id terbesar + 1
    final newId = list.isEmpty
        ? 1
        : list.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    final withId = Catatan(
      id: newId,
      judul: c.judul,
      isi: c.isi,
      kategori: c.kategori,
      dibuatPada: c.dibuatPada,
    );
    list.add(withId);
    await _saveAll(list);
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  Future<void> update(Catatan c) async {
    assert(c.id != null, 'Update memerlukan id yang tidak null');
    final list = await getAll();
    final idx = list.indexWhere((e) => e.id == c.id);
    if (idx != -1) {
      list[idx] = c;
      await _saveAll(list);
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> delete(int id) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == id);
    await _saveAll(list);
  }
}