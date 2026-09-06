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
      FeedScreen(state: widget.state, onSearch: () => setState(() => index = 2)),
      CalendarScreen(state: widget.state),
      SearchScreen(state: widget.state, onBack: () => setState(() => index = 0)),
      SettingsScreen(state: widget.state),
    ];
    return PaperScaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: index == 2
          ? null
          : Container(
              height: 83,
              padding: const EdgeInsets.only(top: 13),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tab(assetPath: 'assets/tab_cards.png', label: '캘린더', active: index == 1, onTap: () => setState(() => index = 1)),
                  _Tab(assetPath: 'assets/tab_main.png', label: '카드', active: index == 0, onTap: () => setState(() => index = 0)),
                  _Tab(assetPath: 'assets/tab_settings.png', label: '설정', active: index == 3, onTap: () => setState(() => index = 3)),
                ],
              ),
            ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.assetPath, required this.label, required this.active, required this.onTap});
  final String assetPath;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final color = ink.withValues(alpha: active ? 1 : 0.28);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                child: Image.asset(assetPath, width: 21, height: 21),
              ),
              if (active) ...[
                const SizedBox(height: 6),
                Text(label, style: TextStyle(fontSize: 10, letterSpacing: 0.6, color: ink)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
