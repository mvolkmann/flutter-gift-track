class Gift {
  DateTime? date;
  String? description;
  int? id;
  String? imageUrl;
  String? location;
  String name;
  int? price;
  bool purchased;
  String? websiteUrl;

  Gift({
    this.id,
    this.purchased = false,
    this.date,
    this.price,
    this.description,
    this.imageUrl,
    this.location,
    required this.name,
    this.websiteUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'location': location,
      'name': name,
      'price': price,
      'purchased': purchased,
      'websiteUrl': websiteUrl,
    };
  }

  @override
  String toString() {
    return 'Gift: $name - $description';
  }
}
