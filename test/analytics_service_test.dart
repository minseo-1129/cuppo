import 'package:cuppo/models/coffee_record.dart';
import 'package:cuppo/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const analytics = AnalyticsService();

  CoffeeRecord record({
    required int id,
    required int day,
    required String menu,
    required String temp,
    required String time,
    String milk = 'none',
    String syrup = 'none',
    String deco = 'none',
  }) {
    return CoffeeRecord(
      id: id,
      date: DateTime(2026, 9, day),
      menu: menu,
      temp: temp,
      milk: milk,
      syrup: syrup,
      deco: deco,
      title: 'record $id',
      memo: '',
      time: time,
    );
  }

  test('monthly report aggregates cups, caffeine, distribution and frequent hour', () {
    final records = [
      record(id: 1, day: 1, menu: 'ame', temp: 'ice', time: '15:10', deco: 'icecube'),
      record(id: 2, day: 1, menu: 'ame', temp: 'hot', time: '15:40'),
      record(id: 3, day: 2, menu: 'latte', temp: 'ice', time: '09:00', milk: 'milk'),
      CoffeeRecord(
        id: 4,
        date: DateTime(2026, 8, 31),
        menu: 'mocha',
        temp: 'hot',
        milk: 'milk',
        syrup: 'mochajar',
        deco: 'none',
        title: 'previous month',
        memo: '',
        time: '10:00',
      ),
    ];

    final report = analytics.buildMonthlyReport(records, DateTime(2026, 9));

    expect(report.cups, 3);
    expect(report.iceCups, 2);
    expect(report.hotCups, 1);
    expect(report.totalCaffeineMg, 340);
    expect(report.mostFrequentHour, 15);
    expect(report.menuDistribution.first.menuKey, 'ame');
    expect(report.menuDistribution.first.count, 2);
    expect(report.caffeineByDay.first.mg, 240);
  });

  test('top combination uses the complete recipe combination', () {
    final records = [
      record(id: 1, day: 1, menu: 'latte', temp: 'ice', time: '12:00', milk: 'milk', deco: 'icecube'),
      record(id: 2, day: 2, menu: 'latte', temp: 'ice', time: '13:00', milk: 'milk', deco: 'icecube'),
      record(id: 3, day: 3, menu: 'latte', temp: 'hot', time: '14:00', milk: 'milk'),
    ];

    final report = analytics.buildMonthlyReport(records, DateTime(2026, 9));

    expect(report.topCombination, isNotNull);
    expect(report.topCombination!.count, 2);
    expect(report.topCombination!.temp, 'ice');
    expect(report.topCombination!.deco, 'icecube');
  });
}
