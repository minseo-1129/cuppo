import 'package:flutter/foundation.dart';

import '../models/coffee_record.dart';
import '../models/monthly_report.dart';
import '../services/analytics_service.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final StorageService _storage;
  final AnalyticsService _analytics = const AnalyticsService();

  bool isReady = false;
  bool onboardingComplete = false;
  bool darkMode = false;
  List<CoffeeRecord> records = <CoffeeRecord>[];

  Future<void> initialize() async {
    records = await _storage.loadRecords();
    onboardingComplete = await _storage.loadOnboardingComplete();
    darkMode = await _storage.loadDarkMode();
    _sortRecords();
    isReady = true;
    notifyListeners();
  }

  List<CoffeeRecord> recordsForMonth(DateTime month) {
    return records.where((record) => record.isInMonth(month)).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  List<DateTime> get recordMonths {
    final months = <String, DateTime>{};
    for (final record in records) {
      final month = DateTime(record.date.year, record.date.month);
      months['${month.year}-${month.month}'] = month;
    }
    final values = months.values.toList()..sort((a, b) => b.compareTo(a));
    return values;
  }

  CoffeeRecord? recordById(int id) {
    for (final record in records) {
      if (record.id == id) return record;
    }
    return null;
  }

  MonthlyReport reportForMonth(DateTime month, {int dailyGoalMg = 400}) {
    return _analytics.buildMonthlyReport(records, month, dailyGoalMg: dailyGoalMg);
  }

  Future<void> completeOnboarding() async {
    onboardingComplete = true;
    notifyListeners();
    await _storage.setOnboardingComplete(true);
  }

  Future<void> toggleDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _storage.setDarkMode(value);
  }

  Future<void> addRecord(CoffeeRecord record) async {
    records = <CoffeeRecord>[record, ...records];
    _sortRecords();
    notifyListeners();
    await _storage.saveRecords(records);
  }

  Future<void> deleteRecord(int id) async {
    records = records.where((record) => record.id != id).toList();
    notifyListeners();
    await _storage.saveRecords(records);
  }

  void _sortRecords() {
    records.sort((a, b) {
      final timeOrder = b.recordedAt.compareTo(a.recordedAt);
      if (timeOrder != 0) return timeOrder;
      return b.id.compareTo(a.id);
    });
  }
}
