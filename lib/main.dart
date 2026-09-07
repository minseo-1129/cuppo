import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state_scope.dart';
import 'services/storage_service.dart';
import 'state/app_state.dart';
import 'widgets/paper_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(StorageService());
  await state.initialize();
  runApp(CuppoApp(state: state));
}

class CuppoApp extends StatelessWidget {
  const CuppoApp({super.key, required this.state});
  final AppState state;

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final ink = dark ? CuppoColors.darkInk : CuppoColors.lightInk;
    final paper = dark ? CuppoColors.darkPaper : CuppoColors.lightPaper;
    final accent = dark ? CuppoColors.darkAccent : CuppoColors.lightAccent;
    final quietInteraction = accent.withValues(alpha: dark ? 0.10 : 0.07);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: Colors.transparent,
      hoverColor: quietInteraction,
      focusColor: quietInteraction,
      splashColor: accent.withValues(alpha: dark ? 0.14 : 0.10),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
        primary: accent,
        surface: paper,
        onSurface: ink,
      ),
      textTheme: ThemeData(brightness: brightness)
          .textTheme
          .apply(bodyColor: ink, displayColor: ink),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: ink.withValues(alpha: 0.20)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ink.withValues(alpha: 0.20)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accent),
        ),
        hintStyle: TextStyle(color: ink.withValues(alpha: 0.35)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: paper,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 3,
        highlightElevation: 2,
        shape: const CircleBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: paper,
        modalBackgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: ink.withValues(alpha: 0.58),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: TextStyle(color: paper),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return AppStateScope(
          state: state,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CUPPO - 커피 기록',
            theme: _theme(Brightness.light),
            darkTheme: _theme(Brightness.dark),
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: state.onboardingComplete
                ? HomeShell(state: state)
                : OnboardingScreen(state: state),
          ),
        );
      },
    );
  }
}
