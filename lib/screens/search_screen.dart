import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../state/app_state.dart';
import '../widgets/record_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.state});
  final AppState state;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  String? menuKey;

  @override
  Widget build(BuildContext context) {
    final lower = query.toLowerCase().trim();
    final results = widget.state.records.where((record) {
      final matchesText = lower.isEmpty || record.title.toLowerCase().contains(lower) || record.memo.toLowerCase().contains(lower);
      final matchesMenu = menuKey == null || record.menu == menuKey;
      return matchesText && matchesMenu;
    }).toList();
    final present = menuCatalog.where((item) => widget.state.records.any((record) => record.menu == item.key)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: '제목·메모 검색'),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(label: '전체', active: menuKey == null, onTap: () => setState(() => menuKey = null)),
              ...present.map((item) => _FilterChip(label: item.name, active: menuKey == item.key, onTap: () => setState(() => menuKey = item.key))),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(child: Text('조건에 맞는 기록이 없어요', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final record = results[index];
                    return RecordCard(record: record, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(record: record))));
                  },
                ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: active ? accent.withValues(alpha: 0.08) : Colors.transparent, border: Border.all(color: active ? accent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20))),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
