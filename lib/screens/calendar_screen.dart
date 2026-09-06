import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import 'detail_screen.dart';

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
    final byDay = <int, List<CoffeeRecord>>{};
    for (final record in widget.state.records) {
      if (record.date.year == month.year && record.date.month == month.month) {
        byDay.putIfAbsent(record.date.day, () => <CoffeeRecord>[]).add(record);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(
            children: [
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)), icon: const Icon(Icons.chevron_left)),
              Expanded(child: Text('${month.year}.${month.month.toString().padLeft(2, '0')}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, letterSpacing: 1.1))),
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)), icon: const Icon(Icons.chevron_right)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: ['일', '월', '화', '수', '목', '금', '토']
                .map((d) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(d, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, letterSpacing: 0.5, color: ink.withValues(alpha: 0.35))))))
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                onTap: records.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: records.first))),
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
      ],
    );
  }
}
