import 'package:flutter/material.dart';

import '../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _SettingsRow(
        title: '다크 모드',
        trailing: Switch(value: state.darkMode, onChanged: state.toggleDarkMode),
      ),
      const _SettingsRow(title: '알림', trailing: Text('준비 중')),
      const _SettingsRow(title: '데이터 백업', trailing: Text('준비 중')),
      const _SettingsRow(title: '폰트', trailing: Text('시스템')),
      const _SettingsRow(title: '앱 정보', trailing: Text('CUPPO')),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        const Text('SETTINGS', style: TextStyle(fontSize: 20, letterSpacing: 1.2)),
        const SizedBox(height: 20),
        ...rows,
        const SizedBox(height: 28),
        Text('VERSION 1.0.0', style: TextStyle(fontSize: 11, letterSpacing: 1.4, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35))),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.title, required this.trailing});
  final String title;
  final Widget trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20)))),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          DefaultTextStyle(style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)), child: trailing),
        ],
      ),
    );
  }
}
