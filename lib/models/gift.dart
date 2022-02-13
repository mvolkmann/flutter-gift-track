class Gift {
  DateTime? date;
  String? description;
  int id;
  String? imageUrl;
  String? location;
  String name;
  int? price;
  bool purchased;
  String? websiteUrl;

  Gift({
    required this.name,
    this.date,
    this.id = 0,
    this.price,
    this.purchased = false,
    this.description,
    this.imageUrl,
    this.location,
    this.websiteUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'location': location,
      'name': name,
      'price': price,
      'purchased': purchased ? 1 : 0,
      'websiteUrl': websiteUrl,
    };
  }

  @override
  String toString() {
    return 'Gift: $name - $description';
  }
}
