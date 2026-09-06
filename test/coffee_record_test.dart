import 'package:flutter_test/flutter_test.dart';
import 'package:cuppo/data/menu_catalog.dart';
import 'package:cuppo/models/coffee_record.dart';

void main() {
  test('illustration path follows decoration rule', () {
    expect(illustrationPath(menu: 'latte', temp: 'hot', deco: 'whipper'), 'assets/ill/hotlatte_wip.webp');
    expect(illustrationPath(menu: 'ame', temp: 'hot', deco: 'whipper'), 'assets/ill/hotame.webp');
    expect(illustrationPath(menu: 'mocha', temp: 'ice', deco: 'icecube'), 'assets/ill/icemocha_ice.webp');
  });

  test('record json round trip', () {
    final record = CoffeeRecord(
      id: 1,
      date: DateTime(2026, 9, 6),
      menu: 'ame',
      temp: 'hot',
      milk: 'none',
      syrup: 'none',
      deco: 'none',
      title: 'Morning',
      memo: 'Good',
      time: '10:00',
    );
    expect(CoffeeRecord.fromJson(record.toJson()).title, 'Morning');
  });
}
