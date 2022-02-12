import './gift.dart';
import './occasion.dart';

class Person {
  int? id;
  DateTime? birthday;
  String name;

  // key is occasion name.
  var giftMap = <String, List<Gift>>{};

  Person({this.birthday, this.id, required this.name});

  void addGift({required Occasion occasion, required Gift gift}) {
    var giftList = giftMap[occasion.name];
    giftList ??= giftMap[occasion.name] = <Gift>[];
    giftList.add(gift);
  }

  void deleteGift({required Occasion occasion, required Gift gift}) {
    var giftList = giftMap[occasion.name];
    if (giftList != null) giftList.remove(gift);
  }

  Map<String, dynamic> toMap() {
    return {'birthday': birthday, 'id': id, 'name': name};
  }

  @override
  String toString() {
    return '$name $birthday';
  }
}
