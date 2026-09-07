import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state_scope.dart';
import '../widgets/cuppo_sheets.dart';
import '../widgets/paper_scaffold.dart';
import '../widgets/record_card.dart';
import 'share_card_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.record});
  final CoffeeRecord record;

  @override
  Widget build(BuildContext context) {
    final menu = menuByKey(record.menu);
    final ink = Theme.of(context).colorScheme.onSurface;
    final items = <(String, String, String)>[
      ('온도', optionLabels[record.temp] ?? record.temp, record.temp),
      ('우유', optionLabels[record.milk] ?? record.milk, record.milk),
      ('시럽', optionLabels[record.syrup] ?? record.syrup, record.syrup),
      ('장식', optionLabels[record.deco] ?? record.deco, record.deco),
    ];

    return PaperScaffold(
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                const Spacer(),
                IconButton(
                  tooltip: '더보기',
                  onPressed: () => _openActions(context),
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(border: hairlineBorder(context)),
                  child: Center(
                    child: Image.asset(
                      recordIllustration(record),
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.coffee_outlined, size: 88),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('#${menu.name}', style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(formatDate(record.date), style: TextStyle(fontSize: 11, letterSpacing: 0.4, color: ink.withValues(alpha: 0.45))),
                  ],
                ),
                const SizedBox(height: 14),
                Text(record.title.isEmpty ? menu.name : record.title, style: const TextStyle(fontSize: 20, height: 1.5)),
                if (record.memo.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(record.memo, style: TextStyle(fontSize: 14, height: 1.9, color: ink.withValues(alpha: 0.62))),
                ],
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.only(top: 18),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: ink.withValues(alpha: 0.16)))),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/sel/${item.$3}.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.coffee_outlined),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(item.$1, style: TextStyle(fontSize: 10, color: ink.withValues(alpha: 0.35))),
                          const SizedBox(height: 2),
                          Text(item.$2, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: ink.withValues(alpha: 0.16)))),
                  child: Row(
                    children: [
                      Text('카페인 ${menu.caffeine}mg', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.52))),
                      const Spacer(),
                      Text(record.time, style: TextStyle(fontSize: 12, letterSpacing: 0.4, color: ink.withValues(alpha: 0.52))),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () => _openShare(context),
                    child: const Text('카드 이미지로 저장'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openShare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShareCardScreen(record: record)),
    );
  }

  Future<void> _openActions(BuildContext context) async {
    final action = await showCuppoSheet<String>(
      context: context,
      child: Builder(
        builder: (sheetContext) {
          final ink = Theme.of(sheetContext).colorScheme.onSurface;
          final accent = Theme.of(sheetContext).colorScheme.primary;

          Widget row({required String label, required String value, Color? color}) {
            return InkWell(
              onTap: () => Navigator.pop(sheetContext, value),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 2),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ink.withValues(alpha: 0.12))),
                ),
                child: Text(label, style: TextStyle(fontSize: 16, color: color ?? ink)),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: ink.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                row(label: '카드 이미지로 저장', value: 'share'),
                row(label: '기록 삭제', value: 'delete', color: accent),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      side: BorderSide(color: ink.withValues(alpha: 0.20)),
                      foregroundColor: ink,
                    ),
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('취소', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (!context.mounted) return;
    if (action == 'share') {
      _openShare(context);
    } else if (action == 'delete') {
      await _delete(context);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final delete = await showCuppoConfirmSheet(
      context: context,
      title: '이 기록을 삭제할까요?',
      message: '삭제한 기록은 되돌릴 수 없습니다.',
      confirmLabel: '기록 삭제',
      cancelLabel: '취소',
      destructive: true,
    );

    if (delete && context.mounted) {
      await AppStateScope.of(context).deleteRecord(record.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}
