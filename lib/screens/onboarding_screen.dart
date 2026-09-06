import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/paper_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.state});
  final AppState state;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int index = 0;

  static const pages = [
    ('assets/ill/hotlatte_wip.png', '오늘 마신 커피,\n한 장의 카드로', '메뉴를 고르고 온도·우유·시럽까지 그대로 남깁니다.'),
    ('assets/ill/icemocha_ice.png', '기록이 쌓여도\n금방 찾을 수 있게', '피드·갤러리·달력에서 다시 보고, 제목과 메모로 검색할 수 있어요.'),
    ('assets/ill/hotcup_wip.png', '내 취향대로\n한 잔씩 기록해요', '레시피와 제목·메모를 남기고, 라이트·다크 모드로 편하게 돌아보세요.'),
  ];

  @override
  Widget build(BuildContext context) {
    final page = pages[index];
    final accent = Theme.of(context).colorScheme.primary;
    return PaperScaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: Center(child: Image.asset(page.$1, fit: BoxFit.contain)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(page.$2, style: const TextStyle(fontSize: 26, height: 1.35, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(page.$3, style: TextStyle(fontSize: 14, height: 1.7, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55))),
            ),
            const SizedBox(height: 26),
            Row(
              children: List.generate(
                pages.length,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: i == index ? accent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20)),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                onPressed: () async {
                  if (index < pages.length - 1) {
                    setState(() => index += 1);
                  } else {
                    await widget.state.completeOnboarding();
                  }
                },
                child: Text(index == pages.length - 1 ? '시작하기' : '다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
