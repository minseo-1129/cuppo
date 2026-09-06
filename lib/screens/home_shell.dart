import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';
import 'calendar_screen.dart';
import 'feed_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.state});
  final AppState state;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      FeedScreen(state: widget.state),
      CalendarScreen(state: widget.state),
      SearchScreen(state: widget.state),
      SettingsScreen(state: widget.state),
    ];
    return PaperScaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: Container(
        height: 68,
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20)))),
        child: Row(
          children: [
            _Tab(icon: Icons.coffee_outlined, label: '기록', active: index == 0, onTap: () => setState(() => index = 0)),
            _Tab(icon: Icons.calendar_month_outlined, label: '달력', active: index == 1, onTap: () => setState(() => index = 1)),
            _Tab(icon: Icons.search, label: '검색', active: index == 2, onTap: () => setState(() => index = 2)),
            _Tab(icon: Icons.settings_outlined, label: '설정', active: index == 3, onTap: () => setState(() => index = 3)),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label, required this.active, required this.onTap});
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final color = active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, letterSpacing: 0.5, color: color)),
          ],
        ),
      ),
    );
  }
}
