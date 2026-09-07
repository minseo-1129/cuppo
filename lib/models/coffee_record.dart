class CoffeeRecord {
  const CoffeeRecord({
    required this.id,
    required this.date,
    required this.menu,
    required this.temp,
    required this.milk,
    required this.syrup,
    required this.deco,
    required this.title,
    required this.memo,
    required this.time,
    this.photo = false,
  });

  final int id;
  final DateTime date;
  final String menu;
  final String temp;
  final String milk;
  final String syrup;
  final String deco;
  final String title;
  final String memo;
  final String time;

  /// Kept only for backwards compatibility with v1 stored records.
  /// Photo capture is intentionally outside the v2 scope for now.
  final bool photo;

  bool get isIced => temp == 'ice';
  bool get isHot => !isIced;

  DateTime get recordedAt {
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  bool isInMonth(DateTime month) =>
      date.year == month.year && date.month == month.month;

  String get monthKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  CoffeeRecord copyWith({
    int? id,
    DateTime? date,
    String? menu,
    String? temp,
    String? milk,
    String? syrup,
    String? deco,
    String? title,
    String? memo,
    String? time,
    bool? photo,
  }) {
    return CoffeeRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      menu: menu ?? this.menu,
      temp: temp ?? this.temp,
      milk: milk ?? this.milk,
      syrup: syrup ?? this.syrup,
      deco: deco ?? this.deco,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      time: time ?? this.time,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'schema': 2,
        'id': id,
        'date': date.toIso8601String(),
        'menu': menu,
        'temp': temp,
        'milk': milk,
        'syrup': syrup,
        'deco': deco,
        'title': title,
        'memo': memo,
        'time': time,
        'photo': photo,
      };

  factory CoffeeRecord.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] as String?;
    final parsedDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    final rawId = json['id'];
    final parsedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ??
            DateTime.now().microsecondsSinceEpoch;

    return CoffeeRecord(
      id: parsedId,
      date: parsedDate == null
          ? DateTime.now()
          : DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
      menu: json['menu'] as String? ?? 'ame',
      temp: json['temp'] as String? ?? 'hot',
      milk: json['milk'] as String? ?? 'none',
      syrup: json['syrup'] as String? ?? 'none',
      deco: json['deco'] as String? ?? 'none',
      title: json['title'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      time: json['time'] as String? ?? '00:00',
      photo: json['photo'] as bool? ?? false,
    );
  }
}
