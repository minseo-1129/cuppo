import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state.dart';
import '../widgets/record_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.state, required this.onBack});
  final AppState state;
  final VoidCallback onBack;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  String? menuKey;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final lower = query.toLowerCase().trim();
    final results = widget.state.records.where((record) {
      final menu = menuByKey(record.menu);
      final matchesText = lower.isEmpty ||
          record.title.toLowerCase().contains(lower) ||
          record.memo.toLowerCase().contains(lower) ||
          menu.name.toLowerCase().contains(lower);
      final matchesMenu = menuKey == null || record.menu == menuKey;
      return matchesText && matchesMenu;
    }).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 20, 8),
          child: Row(
            children: [
              IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back)),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (value) => setState(() => query = value),
                  decoration: const InputDecoration(hintText: '메뉴 · 제목 · 메모 검색'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(label: '전체', active: menuKey == null, onTap: () => setState(() => menuKey = null)),
              ...menuCatalog.map(
                (item) => _FilterChip(
                  label: item.name,
                  active: menuKey == item.key,
                  onTap: () => setState(() => menuKey = menuKey == item.key ? null : item.key),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    '조건에 맞는 기록이 없어요',
                    style: TextStyle(fontSize: 14, color: ink.withValues(alpha: 0.45)),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: ink.withValues(alpha: 0.12)),
                  itemBuilder: (context, index) => _ResultRow(record: results[index]),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '${results.length} RESULTS',
            style: TextStyle(fontSize: 10, letterSpacing: 1.4, color: ink.withValues(alpha: 0.3)),
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.record});
  final CoffeeRecord record;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final menu = menuByKey(record.menu);
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            SizedBox(width: 56, height: 56, child: Image.asset(recordIllustration(record), fit: BoxFit.contain)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.title.isEmpty ? menu.name : record.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(
                    '${menu.name} · ${recipeLine(temp: record.temp, milk: record.milk, syrup: record.syrup, deco: record.deco)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: ink.withValues(alpha: 0.45)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${record.date.month}.${record.date.day.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, letterSpacing: 0.4, color: ink.withValues(alpha: 0.38)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final ink = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: active ? accent.withValues(alpha: 0.08) : Colors.transparent,
            border: Border.all(color: active ? accent : ink.withValues(alpha: 0.20)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
