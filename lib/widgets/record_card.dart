import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import 'paper_scaffold.dart';

String two(int value) => value.toString().padLeft(2, '0');
String formatDate(DateTime date) => '${date.year}.${two(date.month)}.${two(date.day)}';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record, required this.onTap});
  final CoffeeRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final menu = menuByKey(record.menu);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        height: 190,
        decoration: BoxDecoration(border: hairlineBorder(context)),
        padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${menu.name}', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.45))),
                Text(formatDate(record.date), style: TextStyle(fontSize: 12, letterSpacing: 0.4, color: ink.withValues(alpha: 0.45))),
              ],
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  recordIllustration(record),
                  height: 112,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.coffee_outlined, size: 76),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.title.isEmpty ? menu.name : record.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Text(record.time, style: TextStyle(fontSize: 12, letterSpacing: 0.4, color: ink.withValues(alpha: 0.35))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
