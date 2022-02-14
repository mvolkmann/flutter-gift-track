import './gift.dart';
import './occasion.dart';

class Person {
  DateTime? birthday;
  int id;
  String name;

  // key is occasion name.
  var giftMap = <String, List<Gift>>{};

  Person({
    required this.name,
    this.id = 0,
    this.birthday,
  });

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
    return {
      'birthday': birthday?.millisecondsSinceEpoch,
      'id': id,
      'name': name
    };
  }

  @override
  String toString() {
    return 'Person: $id $name $birthday';
  }
}
