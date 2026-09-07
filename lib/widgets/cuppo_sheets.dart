import 'package:flutter/material.dart';

import 'paper_scaffold.dart';

Future<T?> showCuppoSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xFF141413).withValues(alpha: 0.34),
    isScrollControlled: true,
    builder: (sheetContext) {
      return PaperBackground(
        child: SafeArea(
          top: false,
          child: child,
        ),
      );
    },
  );
}

Future<bool> showCuppoConfirmSheet({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = '확인',
  String cancelLabel = '취소',
  bool destructive = false,
}) async {
  final result = await showCuppoSheet<bool>(
    context: context,
    child: Builder(
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final ink = theme.colorScheme.onSurface;
        final accent = theme.colorScheme.primary;
        final actionColor = destructive ? accent : ink;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: ink.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                destructive ? 'DELETE RECORD' : 'CONFIRM',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.8,
                  color: ink.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 20, height: 1.4)),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.7,
                  color: ink.withValues(alpha: 0.48),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ink.withValues(alpha: 0.14)),
                    bottom: BorderSide(color: ink.withValues(alpha: 0.14)),
                  ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 18),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    foregroundColor: actionColor,
                  ),
                  onPressed: () => Navigator.pop(sheetContext, true),
                  child: Text(confirmLabel, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    side: BorderSide(color: ink.withValues(alpha: 0.20)),
                    foregroundColor: ink,
                  ),
                  onPressed: () => Navigator.pop(sheetContext, false),
                  child: Text(cancelLabel, style: const TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return result ?? false;
}
