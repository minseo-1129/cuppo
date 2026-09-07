import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import 'detail_screen.dart';
import 'monthly_report_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.state});
  final AppState state;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    month = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final days = DateTime(month.year, month.month + 1, 0).day;
    final leading = DateTime(month.year, month.month, 1).weekday % 7;
    final totalCells = ((leading + days + 6) ~/ 7) * 7;
    final monthlyRecords = widget.state.recordsForMonth(month);
    final report = widget.state.reportForMonth(month);
    final byDay = <int, List<CoffeeRecord>>{};

    for (final record in monthlyRecords) {
      byDay.putIfAbsent(record.date.day, () => <CoffeeRecord>[]).add(record);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
          child: Row(
            children: [
              IconButton(onPressed: () => _shiftMonth(-1), icon: const Icon(Icons.chevron_left)),
              Expanded(
                child: Column(
                  children: [
                    Text('${month.year}', style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: ink.withValues(alpha: 0.42))),
                    const SizedBox(height: 2),
                    Text(_monthName(month.month), style: const TextStyle(fontSize: 21, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
              IconButton(onPressed: () => _shiftMonth(1), icon: const Icon(Icons.chevron_right)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Text('${report.cups} CUPS', style: TextStyle(fontSize: 11, letterSpacing: 0.7, color: ink.withValues(alpha: 0.4))),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MonthlyReportScreen(state: widget.state, month: month)),
                ),
                child: const Text('이 달의 취향'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, letterSpacing: 0.5, color: ink.withValues(alpha: 0.35)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.86,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final day = index - leading + 1;
              if (day < 1 || day > days) return const SizedBox.expand();

              final records = byDay[day] ?? const <CoffeeRecord>[];
              return InkWell(
                onTap: records.isEmpty ? null : () => _openDay(records),
                child: Stack(
                  children: [
                    if (records.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(recordIllustration(records.first), fit: BoxFit.contain),
                        ),
                      ),
                    Positioned(
                      top: 2,
                      left: 4,
                      child: Text('$day', style: TextStyle(fontSize: 9, color: ink.withValues(alpha: records.isEmpty ? 0.28 : 0.55))),
                    ),
                    if (records.length > 1)
                      Positioned(
                        right: 3,
                        bottom: 2,
                        child: Text('+${records.length - 1}', style: TextStyle(fontSize: 8, color: ink.withValues(alpha: 0.45))),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Container(
            padding: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: ink.withValues(alpha: 0.16)))),
            child: Row(
              children: [
                Text('이번 달 ${report.cups}잔', style: const TextStyle(fontSize: 13)),
                const Spacer(),
                Text(
                  '아이스 ${report.iceCups} · 핫 ${report.hotCups}',
                  style: TextStyle(fontSize: 11, color: ink.withValues(alpha: 0.45)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _shiftMonth(int delta) {
    setState(() => month = DateTime(month.year, month.month + delta));
  }

  void _openDay(List<CoffeeRecord> records) {
    if (records.length == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: records.first)));
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          itemCount: records.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final record = records[index];
            final menu = menuByKey(record.menu);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.asset(recordIllustration(record), width: 44, height: 44, fit: BoxFit.contain),
              title: Text(record.title.isEmpty ? menu.name : record.title),
              subtitle: Text('${menu.name} · ${record.time}'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record)));
              },
            );
          },
        ),
      ),
    );
  }
}

String _monthName(int month) => const [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ][month - 1];
