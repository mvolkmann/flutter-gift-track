import './gift.dart';
import './named.dart';
import './occasion.dart';

class Person extends Named {
  DateTime? birthday;
  int id;

  // key is occasion name.
  var giftMap = <String, List<Gift>>{};

  Person({
    required String name,
    this.id = 0,
    this.birthday,
  }) : super(name: name);

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
