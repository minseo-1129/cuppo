import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/coffee_record.dart';

class StorageService {
  static const _recordsKey = 'cuppo.records.v1';
  static const _onboardingKey = 'cuppo.onboarding.complete';
  static const _darkModeKey = 'cuppo.darkMode';

  Future<List<CoffeeRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recordsKey);
    if (raw == null || raw.isEmpty) return <CoffeeRecord>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => CoffeeRecord.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {
      return <CoffeeRecord>[];
    }
  }

  Future<void> saveRecords(List<CoffeeRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(records.map((record) => record.toJson()).toList());
    await prefs.setString(_recordsKey, raw);
  }

  Future<bool> loadOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }
}
