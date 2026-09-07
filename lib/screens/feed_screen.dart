import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';
import '../widgets/record_card.dart';
import 'detail_screen.dart';
import 'record_flow/menu_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.state, required this.onSearch});
  final AppState state;
  final VoidCallback onSearch;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool grid = false;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final records = widget.state.recordsForMonth(selectedMonth);
    final ink = Theme.of(context).colorScheme.onSurface;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: _openMonthPicker,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selectedMonth.year}',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: ink.withValues(alpha: 0.42),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _monthName(selectedMonth.month),
                                style: const TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Icon(Icons.arrow_drop_down, size: 18, color: ink.withValues(alpha: 0.42)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: '검색',
                    onPressed: widget.onSearch,
                    icon: const Icon(Icons.search, size: 21),
                  ),
                  IconButton(
                    tooltip: grid ? '리스트 보기' : '그리드 보기',
                    onPressed: () => setState(() => grid = !grid),
                    icon: Icon(grid ? Icons.view_agenda_outlined : Icons.grid_view_outlined, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: records.isEmpty
                  ? _EmptyState(month: selectedMonth, onAdd: _startAdd)
                  : grid
                      ? _Grid(records: records)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                          itemCount: records.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return RecordCard(record: record, onTap: () => _openDetail(record));
                          },
                        ),
            ),
            if (records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${records.length} CUPS',
                  style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: ink.withValues(alpha: 0.3)),
                ),
              ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 22,
          child: FloatingActionButton(
            heroTag: 'add-record',
            shape: const CircleBorder(),
            onPressed: _startAdd,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> _openMonthPicker() async {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    final months = <DateTime>[current, ...widget.state.recordMonths];
    final unique = <String, DateTime>{};
    for (final month in months) {
      unique['${month.year}-${month.month}'] = month;
    }
    final options = unique.values.toList()..sort((a, b) => b.compareTo(a));

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final month = options[index];
            final active = month.year == selectedMonth.year && month.month == selectedMonth.month;
            final count = widget.state.recordsForMonth(month).length;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${_monthName(month.month)} ${month.year}', style: const TextStyle(letterSpacing: 0.8)),
              trailing: Text('$count CUPS', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
              leading: active ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18) : const SizedBox(width: 18),
              onTap: () => Navigator.pop(context, month),
            );
          },
        ),
      ),
    );

    if (picked != null && mounted) {
      setState(() => selectedMonth = DateTime(picked.year, picked.month));
    }
  }

  void _startAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
  }

  void _openDetail(CoffeeRecord record) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record)));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.month, required this.onAdd});
  final DateTime month;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.45,
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark ? 'assets/ring_dark.png' : 'assets/ring.png',
                    width: 170,
                  ),
                ),
                Text('0 CUPS', style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: ink.withValues(alpha: 0.35))),
              ],
            ),
            const SizedBox(height: 24),
            Text('${month.month}월에는 아직 기록이 없어요', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('오늘 마신 한 잔부터 남겨볼까요', style: TextStyle(fontSize: 13, color: ink.withValues(alpha: 0.45))),
            const SizedBox(height: 24),
            SizedBox(
              width: 190,
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                onPressed: onAdd,
                child: const Text('첫 기록 남기기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.records});
  final List<CoffeeRecord> records;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record))),
          child: Container(
            decoration: BoxDecoration(border: hairlineBorder(context)),
            padding: const EdgeInsets.all(7),
            child: Stack(
              children: [
                Center(child: Image.asset(recordIllustration(record), fit: BoxFit.contain)),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    record.date.day.toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 9, letterSpacing: 0.5, color: ink.withValues(alpha: 0.42)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
