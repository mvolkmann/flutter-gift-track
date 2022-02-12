class Occasion {
  DateTime? date;
  int? id;
  String name;

  Occasion({this.id, required this.name, this.date});

  Map<String, dynamic> toMap() {
    return {'date': date, 'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Occasion: $name $date';
  }
}
