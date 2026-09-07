import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../models/monthly_report.dart';

class AnalyticsService {
  const AnalyticsService();

  MonthlyReport buildMonthlyReport(
    List<CoffeeRecord> records,
    DateTime month, {
    int dailyGoalMg = 400,
  }) {
    final monthStart = DateTime(month.year, month.month);
    final monthly = records.where((record) => record.isInMonth(monthStart)).toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final menuCounts = <String, int>{};
    final caffeineByDay = <DateTime, int>{};
    final hourCounts = <int, int>{};
    final combinationCounts = <String, int>{};
    final combinationRecords = <String, CoffeeRecord>{};

    var iceCups = 0;
    var totalCaffeine = 0;

    for (final record in monthly) {
      if (record.isIced) iceCups++;

      menuCounts.update(record.menu, (value) => value + 1, ifAbsent: () => 1);

      final caffeine = menuByKey(record.menu).caffeine;
      totalCaffeine += caffeine;
      final day = DateTime(record.date.year, record.date.month, record.date.day);
      caffeineByDay.update(day, (value) => value + caffeine, ifAbsent: () => caffeine);

      final hour = record.recordedAt.hour;
      hourCounts.update(hour, (value) => value + 1, ifAbsent: () => 1);

      final combinationKey = [record.menu, record.temp, record.milk, record.syrup, record.deco].join('|');
      combinationCounts.update(combinationKey, (value) => value + 1, ifAbsent: () => 1);
      combinationRecords.putIfAbsent(combinationKey, () => record);
    }

    final distribution = menuCounts.entries
        .map((entry) => MenuDistributionEntry(
              menuKey: entry.key,
              count: entry.value,
              total: monthly.length,
            ))
        .toList()
      ..sort((a, b) {
        final countOrder = b.count.compareTo(a.count);
        if (countOrder != 0) return countOrder;
        return menuByKey(a.menuKey).name.compareTo(menuByKey(b.menuKey).name);
      });

    final caffeineDays = caffeineByDay.entries
        .map((entry) => DailyCaffeineEntry(date: entry.key, mg: entry.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    int? mostFrequentHour;
    var mostFrequentHourCount = -1;
    for (final entry in hourCounts.entries) {
      if (entry.value > mostFrequentHourCount ||
          (entry.value == mostFrequentHourCount &&
              (mostFrequentHour == null || entry.key < mostFrequentHour))) {
        mostFrequentHour = entry.key;
        mostFrequentHourCount = entry.value;
      }
    }

    CoffeeCombination? topCombination;
    String? topKey;
    var topCount = -1;
    for (final entry in combinationCounts.entries) {
      if (entry.value > topCount) {
        topKey = entry.key;
        topCount = entry.value;
      }
    }
    if (topKey != null) {
      final record = combinationRecords[topKey]!;
      topCombination = CoffeeCombination(
        menu: record.menu,
        temp: record.temp,
        milk: record.milk,
        syrup: record.syrup,
        deco: record.deco,
        count: topCount,
      );
    }

    return MonthlyReport(
      month: monthStart,
      records: List<CoffeeRecord>.unmodifiable(monthly),
      iceCups: iceCups,
      hotCups: monthly.length - iceCups,
      totalCaffeineMg: totalCaffeine,
      dailyGoalMg: dailyGoalMg,
      menuDistribution: List<MenuDistributionEntry>.unmodifiable(distribution),
      caffeineByDay: List<DailyCaffeineEntry>.unmodifiable(caffeineDays),
      mostFrequentHour: mostFrequentHour,
      topCombination: topCombination,
    );
  }
}
