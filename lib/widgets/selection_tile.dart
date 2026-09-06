import 'package:flutter/material.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.assetPath,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.05) : Colors.transparent,
          border: Border.all(
            color: selected ? accent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (assetPath != null)
                  Expanded(
                    child: Image.asset(
                      assetPath!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.coffee_outlined),
                    ),
                  ),
                if (assetPath != null) const SizedBox(height: 4),
                SizedBox(width: double.infinity, child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              ],
            ),
            if (selected)
              Positioned(
                right: 0,
                top: 0,
                child: Icon(Icons.check, size: 14, color: accent),
              ),
          ],
        ),
      ),
    );
  }
}
