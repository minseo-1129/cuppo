import 'coffee_record.dart';

class CoffeeCombination {
  const CoffeeCombination({
    required this.menu,
    required this.temp,
    required this.milk,
    required this.syrup,
    required this.deco,
    required this.count,
  });

  final String menu;
  final String temp;
  final String milk;
  final String syrup;
  final String deco;
  final int count;
}

class MenuDistributionEntry {
  const MenuDistributionEntry({
    required this.menuKey,
    required this.count,
    required this.total,
  });

  final String menuKey;
  final int count;
  final int total;

  double get ratio => total == 0 ? 0 : count / total;
}

class DailyCaffeineEntry {
  const DailyCaffeineEntry({required this.date, required this.mg});

  final DateTime date;
  final int mg;
}

class MonthlyReport {
  const MonthlyReport({
    required this.month,
    required this.records,
    required this.iceCups,
    required this.hotCups,
    required this.totalCaffeineMg,
    required this.dailyGoalMg,
    required this.menuDistribution,
    required this.caffeineByDay,
    required this.mostFrequentHour,
    required this.topCombination,
  });

  final DateTime month;
  final List<CoffeeRecord> records;
  final int iceCups;
  final int hotCups;
  final int totalCaffeineMg;
  final int dailyGoalMg;
  final List<MenuDistributionEntry> menuDistribution;
  final List<DailyCaffeineEntry> caffeineByDay;
  final int? mostFrequentHour;
  final CoffeeCombination? topCombination;

  int get cups => records.length;
  bool get isEmpty => records.isEmpty;
  double get iceRatio => cups == 0 ? 0 : iceCups / cups;

  int get exceededGoalDays =>
      caffeineByDay.where((entry) => entry.mg >= dailyGoalMg).length;

  int get averageCaffeinePerCup =>
      cups == 0 ? 0 : (totalCaffeineMg / cups).round();
}
