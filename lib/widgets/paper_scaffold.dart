import 'package:flutter/material.dart';

class CuppoColors {
  static const lightPaper = Color(0xFFF3F3F1);
  static const darkPaper = Color(0xFF2C2C2B);
  static const lightInk = Color(0xFF1F1F1E);
  static const darkInk = Color(0xFFEDEDEA);
  static const lightAccent = Color(0xFF8A5A3A);
  static const darkAccent = Color(0xFFC08A5C);
  static const filmDark = Color(0xFF333333);
}

class PaperBackground extends StatelessWidget {
  const PaperBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? CuppoColors.darkPaper : CuppoColors.lightPaper,
        image: DecorationImage(
          image: AssetImage(dark ? 'assets/paper_dark.webp' : 'assets/paper.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

class PaperScaffold extends StatelessWidget {
  const PaperScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: PaperBackground(child: SafeArea(child: body)),
      bottomNavigationBar: bottomNavigationBar == null
          ? null
          : PaperBackground(
              child: SafeArea(top: false, child: bottomNavigationBar!),
            ),
      floatingActionButton: floatingActionButton,
    );
  }
}

BoxBorder hairlineBorder(BuildContext context, {Color? color}) {
  final ink = color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20);
  return Border.all(color: ink, width: 1);
}
