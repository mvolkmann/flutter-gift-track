class Gift {
  DateTime? date;
  String? description;
  int id;
  String? imageUrl;
  String? location;
  String name;
  int occasionId;
  int personId;
  String? photo;
  int? price;
  bool purchased;
  String? websiteUrl;

  Gift({
    this.date,
    this.description,
    this.id = 0,
    this.imageUrl,
    this.location,
    required this.name,
    this.occasionId = 0,
    this.personId = 0,
    this.photo,
    this.price,
    this.purchased = false,
    this.websiteUrl,
  });

  Gift clone() {
    return Gift(
      date: date,
      description: description,
      imageUrl: imageUrl,
      location: location,
      name: name,
      occasionId: occasionId,
      personId: personId,
      photo: photo,
      price: price,
      purchased: purchased,
      websiteUrl: websiteUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'location': location,
      'name': name,
      'occasionId': occasionId,
      'personId': personId,
      'photo': photo,
      'price': price,
      'purchased': purchased ? 1 : 0,
      'websiteUrl': websiteUrl,
    };
  }

  @override
  String toString() {
    return 'Gift: $id/$personId/$occasionId $name photo=$photo';
  }
}
