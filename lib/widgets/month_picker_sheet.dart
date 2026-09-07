import 'package:flutter/material.dart';

import '../models/coffee_record.dart';

const _monthLabels = <String>[
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];

Future<DateTime?> showCuppoMonthPicker(
  BuildContext context, {
  required DateTime initialMonth,
  required List<CoffeeRecord> records,
}) {
  final now = DateTime.now();
  final recordYears = records.map((record) => record.date.year).toList();
  final minRecordYear = recordYears.isEmpty
      ? now.year
      : recordYears.reduce((a, b) => a < b ? a : b);
  final maxRecordYear = recordYears.isEmpty
      ? now.year
      : recordYears.reduce((a, b) => a > b ? a : b);
  final minYear = [minRecordYear, initialMonth.year, now.year]
          .reduce((a, b) => a < b ? a : b) -
      1;
  final maxYear = [maxRecordYear, initialMonth.year, now.year]
          .reduce((a, b) => a > b ? a : b) +
      1;

  var year = initialMonth.year;

  return showModalBottomSheet<DateTime>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final ink = Theme.of(context).colorScheme.onSurface;
          final accent = Theme.of(context).colorScheme.primary;
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: year > minYear
                            ? () => setSheetState(() => year--)
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          '$year',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: year < maxYear
                            ? () => setSheetState(() => year++)
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.15,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final selected = year == initialMonth.year &&
                          month == initialMonth.month;
                      final hasRecords = records.any((record) =>
                          record.date.year == year &&
                          record.date.month == month);
                      return InkWell(
                        onTap: () => Navigator.pop(
                          context,
                          DateTime(year, month),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? accent.withValues(alpha: 0.10)
                                : Colors.transparent,
                            border: Border.all(
                              color: selected
                                  ? accent
                                  : ink.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _monthLabels[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.8,
                                  color: ink.withValues(
                                    alpha: hasRecords || selected ? 1 : 0.45,
                                  ),
                                ),
                              ),
                              if (hasRecords) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
