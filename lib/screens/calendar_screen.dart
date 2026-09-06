import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';
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
    final days = DateTime(month.year, month.month + 1, 0).day;
    final leading = DateTime(month.year, month.month, 1).weekday % 7;
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
          child: Row(children: ['일','월','화','수','목','금','토'].map((d) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(d, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)))))).toList()),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.68),
            itemCount: leading + days,
            itemBuilder: (context, index) {
              if (index < leading) return const SizedBox.shrink();
              final day = index - leading + 1;
              final records = byDay[day] ?? const <CoffeeRecord>[];
              return InkWell(
                onTap: records.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: records.first))),
                child: Container(
                  decoration: BoxDecoration(border: hairlineBorder(context)),
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.topLeft, child: Text('$day', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: records.isEmpty ? 0.28 : 0.75)))),
                      if (records.isNotEmpty)
                        Expanded(child: Image.asset(recordIllustration(records.first), fit: BoxFit.contain)),
                      if (records.length > 1) Text('+${records.length - 1}', style: const TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
