import 'package:flutter/material.dart';

import '../../data/menu_catalog.dart';
import '../../models/coffee_record.dart';
import '../../state/app_state_scope.dart';
import '../../widgets/paper_scaffold.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({
    super.key,
    required this.menuKey,
    required this.temp,
    required this.milk,
    required this.syrup,
    required this.deco,
  });

  final String menuKey;
  final String temp;
  final String milk;
  final String syrup;
  final String deco;

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final titleController = TextEditingController();
  final memoController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menu = menuByKey(widget.menuKey);
    final ink = Theme.of(context).colorScheme.onSurface;

    return PaperScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                const Spacer(),
                Text('STEP 2 / 2', style: TextStyle(fontSize: 11, letterSpacing: 1.8, color: ink.withValues(alpha: 0.40))),
                const SizedBox(width: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(border: hairlineBorder(context)),
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('#${menu.name}', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.48))),
                          const Spacer(),
                          Text(_todayLabel(), style: TextStyle(fontSize: 11, color: ink.withValues(alpha: 0.42))),
                        ],
                      ),
                      Expanded(
                        child: Image.asset(
                          illustrationPath(menu: widget.menuKey, temp: widget.temp, deco: widget.deco),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          titleController.text.trim().isEmpty ? '제목 없음' : titleController.text.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: ink.withValues(alpha: 0.52)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('제목', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.42))),
                TextField(
                  controller: titleController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(hintText: '한 줄로 남기기'),
                ),
                const SizedBox(height: 20),
                Text('메모', style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.42))),
                TextField(
                  controller: memoController,
                  maxLines: 4,
                  minLines: 3,
                  style: const TextStyle(fontSize: 14, height: 1.7),
                  decoration: const InputDecoration(hintText: '맛, 장소, 기분'),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: ink.withValues(alpha: 0.14)),
                      bottom: BorderSide(color: ink.withValues(alpha: 0.14)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipeLine(temp: widget.temp, milk: widget.milk, syrup: widget.syrup, deco: widget.deco),
                          style: TextStyle(fontSize: 12, height: 1.5, color: ink.withValues(alpha: 0.48)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${menu.caffeine}mg', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: _save,
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final inherited = AppStateScope.of(context);
    final now = DateTime.now();
    final menu = menuByKey(widget.menuKey);
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final record = CoffeeRecord(
      id: now.microsecondsSinceEpoch,
      date: DateTime(now.year, now.month, now.day),
      menu: widget.menuKey,
      temp: widget.temp,
      milk: widget.milk,
      syrup: widget.syrup,
      deco: widget.deco,
      title: titleController.text.trim().isEmpty ? menu.name : titleController.text.trim(),
      memo: memoController.text.trim(),
      time: time,
    );
    await inherited.addRecord(record);
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('커피 기록을 저장했어요.')));
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
  }
}
