class Occasion {
  DateTime? date;
  int id;
  String name;

  Occasion({
    required this.name,
    this.id = 0,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Occasion: $id $name $date';
  }
}
