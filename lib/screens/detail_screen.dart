import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../state/app_state_scope.dart';
import '../widgets/paper_scaffold.dart';
import '../widgets/record_card.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.record});
  final CoffeeRecord record;

  @override
  Widget build(BuildContext context) {
    final menu = menuByKey(record.menu);
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
                  onPressed: () async {
                    final delete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        title: const Text('기록을 삭제할까요?'),
                        content: const Text('삭제한 기록은 되돌릴 수 없습니다.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                        ],
                      ),
                    );
                    if (delete == true && context.mounted) {
                      await AppStateScope.of(context).deleteRecord(record.id);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              children: [
                SizedBox(height: 240, child: Image.asset(recordIllustration(record), fit: BoxFit.contain)),
                Text(record.title, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 8),
                Text('${formatDate(record.date)} · ${record.time}', style: TextStyle(fontSize: 12, letterSpacing: 0.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
                if (record.memo.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(record.memo, style: const TextStyle(fontSize: 16, height: 1.8)),
                ],
                const SizedBox(height: 28),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 0, mainAxisSpacing: 0, childAspectRatio: 0.72),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      decoration: BoxDecoration(border: hairlineBorder(context)),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Image.asset('assets/sel/${item.$3}.webp', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.coffee_outlined))),
                          const SizedBox(height: 4),
                          Text(item.$1, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
                          const SizedBox(height: 2),
                          Text(item.$2, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text('${menu.caffeine} mg', style: const TextStyle(fontSize: 14, letterSpacing: 0.7)),
                    const SizedBox(width: 8),
                    Text('카페인 · 일 400mg 기준', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
