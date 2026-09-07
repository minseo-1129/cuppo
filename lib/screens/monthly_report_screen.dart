import 'package:flutter/material.dart';

import '../data/menu_catalog.dart';
import '../models/monthly_report.dart';
import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key, required this.state, required this.month});

  final AppState state;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final report = state.reportForMonth(month);
    final ink = Theme.of(context).colorScheme.onSurface;
    final accent = Theme.of(context).colorScheme.primary;

    return PaperScaffold(
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                Text('${month.month}월의 취향', style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Expanded(
            child: report.isEmpty
                ? Center(
                    child: Text(
                      '이 달의 기록이 아직 없어요',
                      style: TextStyle(fontSize: 14, color: ink.withValues(alpha: 0.45)),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
                    children: [
                      _TopCombination(report: report),
                      const SizedBox(height: 34),
                      Text('메뉴 분포', style: TextStyle(fontSize: 12, letterSpacing: 0.8, color: ink.withValues(alpha: 0.45))),
                      const SizedBox(height: 14),
                      ...report.menuDistribution.take(5).map((entry) {
                        final menu = menuByKey(entry.menuKey);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Row(
                            children: [
                              SizedBox(width: 84, child: Text(menu.name, style: const TextStyle(fontSize: 12))),
                              Expanded(
                                child: ClipRect(
                                  child: LinearProgressIndicator(
                                    minHeight: 5,
                                    value: entry.ratio,
                                    backgroundColor: ink.withValues(alpha: 0.10),
                                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(width: 28, child: Text('${entry.count}', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, color: ink.withValues(alpha: 0.45)))),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Text('카페인 흐름', style: TextStyle(fontSize: 12, letterSpacing: 0.8, color: ink.withValues(alpha: 0.45))),
                          const Spacer(),
                          Text('일 ${report.dailyGoalMg}mg 기준', style: TextStyle(fontSize: 11, color: ink.withValues(alpha: 0.35))),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _CaffeineBars(report: report),
                      const SizedBox(height: 10),
                      Text(
                        report.exceededGoalDays == 0
                            ? '목표선에 닿은 날이 없었어요.'
                            : '${report.exceededGoalDays}일이 일일 목표선에 닿았어요.',
                        style: TextStyle(fontSize: 11, height: 1.6, color: ink.withValues(alpha: 0.40)),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: ink.withValues(alpha: 0.16)))),
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            _StatRow(label: '이번 달', value: '${report.cups}잔'),
                            _StatRow(label: '아이스 비율', value: '${(report.iceRatio * 100).round()}%'),
                            _StatRow(label: '가장 자주 마신 시간', value: _hourLabel(report.mostFrequentHour)),
                            _StatRow(label: '총 카페인', value: '${report.totalCaffeineMg}mg'),
                            _StatRow(label: '한 잔 평균 카페인', value: '${report.averageCaffeinePerCup}mg'),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TopCombination extends StatelessWidget {
  const _TopCombination({required this.report});
  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final top = report.topCombination!;
    final menu = menuByKey(top.menu);
    return Column(
      children: [
        Text('가장 많이 마신 조합', style: TextStyle(fontSize: 12, letterSpacing: 0.6, color: ink.withValues(alpha: 0.45))),
        const SizedBox(height: 10),
        Image.asset(
          illustrationPath(menu: top.menu, temp: top.temp, deco: top.deco),
          width: 154,
          height: 154,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text('${optionLabels[top.temp] ?? top.temp} ${menu.name}', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 7),
        Text(
          '${recipeLine(temp: top.temp, milk: top.milk, syrup: top.syrup, deco: top.deco)} · ${top.count}잔',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, height: 1.5, color: ink.withValues(alpha: 0.48)),
        ),
      ],
    );
  }
}

class _CaffeineBars extends StatelessWidget {
  const _CaffeineBars({required this.report});
  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final accent = Theme.of(context).colorScheme.primary;
    final entries = report.caffeineByDay;

    return SizedBox(
      height: 126,
      child: entries.isEmpty
          ? Center(child: Text('카페인 기록이 없어요', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.35))))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final ratio = (entry.mg / report.dailyGoalMg).clamp(0.04, 1.0);
                final reached = entry.mg >= report.dailyGoalMg;
                return SizedBox(
                  width: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${entry.mg}', style: TextStyle(fontSize: 8, color: ink.withValues(alpha: 0.42))),
                      const SizedBox(height: 5),
                      Container(
                        width: 24,
                        height: 78 * ratio,
                        color: reached ? accent : ink.withValues(alpha: 0.24),
                      ),
                      const SizedBox(height: 6),
                      Text('${entry.date.day}', style: TextStyle(fontSize: 9, color: ink.withValues(alpha: 0.38))),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: ink.withValues(alpha: 0.52))),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

String _hourLabel(int? hour) {
  if (hour == null) return '—';
  if (hour == 0) return '자정 무렵';
  if (hour < 12) return '오전 $hour시 무렵';
  if (hour == 12) return '낮 12시 무렵';
  return '오후 ${hour - 12}시 무렵';
}
