import 'package:flutter/material.dart';

import '../../data/menu_catalog.dart';
import '../../widgets/paper_scaffold.dart';
import '../../widgets/selection_tile.dart';
import 'recipe_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selected = 'ame';

  @override
  Widget build(BuildContext context) {
    return PaperScaffold(
      body: Column(
        children: [
          _FlowHeader(title: 'STEP 1 · MENU', onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                const Text('오늘의 커피는?', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.82),
                  itemCount: menuCatalog.length,
                  itemBuilder: (context, index) {
                    final item = menuCatalog[index];
                    return SelectionTile(
                      label: item.name,
                      selected: selected == item.key,
                      assetPath: 'assets/ill/hot${item.key}.png',
                      onTap: () => setState(() => selected = item.key),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeScreen(menuKey: selected)));
                    },
                    child: const Text('다음'),
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

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          Text(title, style: TextStyle(fontSize: 11, letterSpacing: 1.8, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45))),
        ],
      ),
    );
  }
}
