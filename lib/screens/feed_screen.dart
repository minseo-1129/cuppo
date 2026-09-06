import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';
import '../widgets/record_card.dart';
import 'detail_screen.dart';
import 'record_flow/menu_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.state});
  final AppState state;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool grid = false;

  @override
  Widget build(BuildContext context) {
    final records = widget.state.records;
    final now = DateTime.now();
    final label = _monthName(now.month);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(label, style: const TextStyle(fontSize: 22, letterSpacing: 1.3, fontWeight: FontWeight.w300)),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('${now.year}', style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                children: [
                  _Segment(label: '리스트', active: !grid, onTap: () => setState(() => grid = false)),
                  _Segment(label: '갤러리', active: grid, onTap: () => setState(() => grid = true)),
                ],
              ),
            ),
            Expanded(
              child: records.isEmpty
                  ? _EmptyState(onAdd: _startAdd)
                  : grid
                      ? _Grid(records: records)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
                          itemCount: records.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return RecordCard(record: record, onTap: () => _openDetail(record));
                          },
                        ),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 22,
          child: FloatingActionButton(
            heroTag: 'add-record',
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: _startAdd,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _startAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
  }

  void _openDetail(CoffeeRecord record) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record)));
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? ink : ink.withValues(alpha: 0.15)))),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: ink.withValues(alpha: active ? 1 : 0.35))),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(opacity: 0.45, child: Image.asset(Theme.of(context).brightness == Brightness.dark ? 'assets/ring_dark.webp' : 'assets/ring.webp', width: 170)),
            const SizedBox(height: 24),
            const Text('아직 기록한 커피가 없어요', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 14),
            SizedBox(
              width: 190,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                onPressed: onAdd,
                child: const Text('첫 커피 기록하기'),
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
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record))),
          child: Container(
            decoration: BoxDecoration(border: hairlineBorder(context)),
            padding: const EdgeInsets.all(7),
            child: Image.asset(recordIllustration(record), fit: BoxFit.contain),
          ),
        );
      },
    );
  }
}

String _monthName(int month) => const ['JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'][month - 1];
