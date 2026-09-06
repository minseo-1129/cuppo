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
  final bool photo;

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
    return CoffeeRecord(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      menu: json['menu'] as String,
      temp: json['temp'] as String,
      milk: json['milk'] as String,
      syrup: json['syrup'] as String,
      deco: json['deco'] as String,
      title: json['title'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      time: json['time'] as String? ?? '',
      photo: json['photo'] as bool? ?? false,
    );
  }
}
