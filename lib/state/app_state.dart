import 'package:flutter/foundation.dart';

import '../models/coffee_record.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);
  final StorageService _storage;

  bool isReady = false;
  bool onboardingComplete = false;
  bool darkMode = false;
  List<CoffeeRecord> records = <CoffeeRecord>[];

  Future<void> initialize() async {
    records = await _storage.loadRecords();
    onboardingComplete = await _storage.loadOnboardingComplete();
    darkMode = await _storage.loadDarkMode();
    isReady = true;
    notifyListeners();
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
    records = <CoffeeRecord>[record, ...records]
      ..sort((a, b) {
        final dateOrder = b.date.compareTo(a.date);
        if (dateOrder != 0) return dateOrder;
        return b.id.compareTo(a.id);
      });
    notifyListeners();
    await _storage.saveRecords(records);
  }

  Future<void> deleteRecord(int id) async {
    records = records.where((record) => record.id != id).toList();
    notifyListeners();
    await _storage.saveRecords(records);
  }
}
