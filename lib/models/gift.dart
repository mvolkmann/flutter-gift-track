class Gift {
  bool purchased;
  DateTime? date;
  int? price;
  String? description;
  String? imageUrl;
  String? location;
  String name;
  String? websiteUrl;

  Gift({
    this.purchased = false,
    this.date,
    this.price,
    this.description,
    this.imageUrl,
    this.location,
    required this.name,
    this.websiteUrl,
  });
}
