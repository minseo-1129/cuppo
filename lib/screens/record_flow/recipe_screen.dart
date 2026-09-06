import 'package:flutter/material.dart';

import '../../data/menu_catalog.dart';
import '../../widgets/paper_scaffold.dart';
import '../../widgets/selection_tile.dart';
import 'save_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.menuKey});
  final String menuKey;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String temp = 'hot';
  String milk = 'none';
  String syrup = 'none';
  String deco = 'none';
  int group = 0;

  static const groups = ['온도', '우유', '시럽', '장식'];
  static const options = [
    ['hot', 'ice'],
    ['none', 'milk', 'milkfoam'],
    ['none', 'chojar', 'crmjar', 'mochajar', 'matjar', 'strwjar'],
    ['none', 'whipper', 'icecube'],
  ];

  String currentForGroup() => [temp, milk, syrup, deco][group];

  void select(String key) {
    setState(() {
      switch (group) {
        case 0:
          temp = key;
          if (temp == 'hot' && deco == 'icecube') deco = 'none';
          break;
        case 1:
          milk = key;
          break;
        case 2:
          syrup = key;
          break;
        case 3:
          deco = key;
          if (deco == 'icecube') temp = 'ice';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menu = menuByKey(widget.menuKey);
    return PaperScaffold(
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                Text('STEP 2 · RECIPE', style: TextStyle(fontSize: 11, letterSpacing: 1.8, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                SizedBox(
                  height: 170,
                  child: Image.asset(illustrationPath(menu: widget.menuKey, temp: temp, deco: deco), fit: BoxFit.contain),
                ),
                Text(menu.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(recipeLine(temp: temp, milk: milk, syrup: syrup, deco: deco), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55))),
                const SizedBox(height: 28),
                Row(
                  children: List.generate(groups.length, (i) {
                    final active = i == group;
                    return Expanded(
                      child: InkWell(
                        onTap: () => setState(() => group = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? Theme.of(context).colorScheme.onSurface : Colors.transparent, width: 1))),
                          child: Text(groups[i], textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: active ? 1 : 0.35))),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.9),
                  itemCount: options[group].length,
                  itemBuilder: (context, index) {
                    final key = options[group][index];
                    return SelectionTile(
                      label: optionLabels[key] ?? key,
                      selected: currentForGroup() == key,
                      assetPath: 'assets/sel/$key.webp',
                      onTap: () => select(key),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SaveScreen(menuKey: widget.menuKey, temp: temp, milk: milk, syrup: syrup, deco: deco),
                        ),
                      );
                    },
                    child: const Text('저장하기'),
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
