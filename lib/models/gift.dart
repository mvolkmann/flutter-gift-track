class Gift {
  static const defaultZoom = 14.0;

  DateTime? date;
  String? description;
  int id;
  String? imageUrl;
  double? latitude;
  String? location;
  double? longitude;
  String name;
  int occasionId;
  int personId;
  String? photo;
  int? price;
  bool purchased;
  String? websiteUrl;
  double zoom;

  Gift({
    this.date,
    this.description,
    this.id = 0,
    this.imageUrl,
    this.latitude,
    this.location,
    this.longitude,
    required this.name,
    this.occasionId = 0,
    this.personId = 0,
    this.photo,
    this.price,
    this.purchased = false,
    this.websiteUrl,
    this.zoom = defaultZoom,
  });

  Gift get clone => Gift(
        date: date,
        description: description,
        id: id,
        imageUrl: imageUrl,
        latitude: latitude,
        location: location,
        longitude: longitude,
        name: name,
        occasionId: occasionId,
        personId: personId,
        photo: photo,
        price: price,
        purchased: purchased,
        websiteUrl: websiteUrl,
        zoom: zoom,
      );

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'location': location,
      'longitude': longitude,
      'name': name,
      'occasionId': occasionId,
      'personId': personId,
      'photo': photo,
      'price': price,
      'purchased': purchased ? 1 : 0,
      'websiteUrl': websiteUrl,
      'zoom': zoom,
    };
  }

  @override
  String toString() {
    return 'Gift: $id/$personId/$occasionId $name photo=$photo';
  }
}
