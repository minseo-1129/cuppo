import '../models/coffee_record.dart';

class MenuItemData {
  const MenuItemData({required this.key, required this.name, required this.caffeine});
  final String key;
  final String name;
  final int caffeine;
}

const menuCatalog = <MenuItemData>[
  MenuItemData(key: 'ame', name: '아메리카노', caffeine: 120),
  MenuItemData(key: 'latte', name: '카페라떼', caffeine: 100),
  MenuItemData(key: 'cup', name: '카푸치노', caffeine: 100),
  MenuItemData(key: 'mocha', name: '카페모카', caffeine: 110),
  MenuItemData(key: 'cho', name: '핫초코', caffeine: 20),
  MenuItemData(key: 'crm', name: '카라멜크림', caffeine: 95),
  MenuItemData(key: 'mat', name: '말차라떼', caffeine: 60),
  MenuItemData(key: 'strw', name: '딸기라떼', caffeine: 0),
];

const optionLabels = <String, String>{
  'hot': '따뜻하게',
  'ice': '차갑게',
  'none': '없음',
  'milk': '우유',
  'milkfoam': '우유거품',
  'chojar': '초코',
  'crmjar': '카라멜',
  'mochajar': '모카',
  'matjar': '말차',
  'strwjar': '딸기',
  'whipper': '휘핑',
  'icecube': '얼음 추가',
};

MenuItemData menuByKey(String key) =>
    menuCatalog.firstWhere((item) => item.key == key, orElse: () => menuCatalog.first);

String illustrationPath({
  required String menu,
  required String temp,
  required String deco,
}) {
  final base = temp == 'hot' ? 'assets/ill/hot$menu' : 'assets/ill/ice$menu';
  if (temp == 'hot' && deco == 'whipper' && menu != 'ame') {
    return '${base}_wip.png';
  }
  if (temp == 'ice' && deco == 'icecube') {
    return '${base}_ice.png';
  }
  return '$base.png';
}

String recordIllustration(CoffeeRecord record) => illustrationPath(
      menu: record.menu,
      temp: record.temp,
      deco: record.deco,
    );

String recipeLine({
  required String temp,
  required String milk,
  required String syrup,
  required String deco,
}) {
  final parts = <String>[
    optionLabels[temp] ?? temp,
    if (milk != 'none') optionLabels[milk] ?? milk,
    if (syrup != 'none') '${optionLabels[syrup] ?? syrup} 시럽',
    if (deco != 'none') optionLabels[deco] ?? deco,
  ];
  return parts.join(' · ');
}
