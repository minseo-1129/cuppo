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
    return PaperScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                Text('SAVE', style: TextStyle(fontSize: 11, letterSpacing: 1.8, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                SizedBox(height: 170, child: Image.asset(illustrationPath(menu: widget.menuKey, temp: widget.temp, deco: widget.deco), fit: BoxFit.contain)),
                Text(menu.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(recipeLine(temp: widget.temp, milk: widget.milk, syrup: widget.syrup, deco: widget.deco), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55))),
                const SizedBox(height: 28),
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(hintText: '제목을 입력하세요'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: memoController,
                  maxLines: 6,
                  minLines: 4,
                  style: const TextStyle(fontSize: 16, height: 1.8),
                  decoration: const InputDecoration(hintText: '오늘 커피에 대한 메모를 남겨보세요'),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('사진 기능은 v1.1에서 연결할 예정이에요.')));
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(border: hairlineBorder(context)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: const Row(children: [Icon(Icons.add_a_photo_outlined, size: 20), SizedBox(width: 12), Text('사진 추가')]),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () async {
                      final inherited = AppStateScope.of(context);
                      final now = DateTime.now();
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
                      if (!context.mounted) return;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('커피 기록을 저장했어요.')));
                    },
                    child: const Text('기록 저장'),
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
