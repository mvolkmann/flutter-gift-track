import 'package:sqflite/sqflite.dart';
import '../models/gift.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../util.dart' show msToDateTime;

class GiftService {
  final Database database;

  GiftService({required this.database});

  Future<Gift> create({
    required Person person,
    required Occasion occasion,
    required Gift gift,
  }) async {
    var map = gift.toMap();
    map['personId'] = person.id;
    map['occasionId'] = occasion.id;
    // Removing the id allows the insert to assign an id.
    map.remove('id');
    gift.id = await database.insert('gifts', map);
    return gift;
  }

  Future<void> delete(int id) {
    return database.delete(
      'gifts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() {
    return database.delete('gifts');
  }

  Future<Map<int, Gift>> get({
    required Person person,
    required Occasion occasion,
  }) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'gifts',
      where: 'personId = ? and occasionId = ?',
      whereArgs: [person.id, occasion.id],
    );
    return <int, Gift>{
      for (var map in maps)
        map['id']: Gift(
          date: msToDateTime(map['date']),
          description: map['description'],
          id: map['id'],
          imageUrl: map['imageUrl'],
          location: map['location'],
          name: map['name'],
          occasionId: map['occasionId'],
          personId: map['personId'],
          photo: map['photo'],
          price: map['price'],
          purchased: map['purchased'] == 1,
          websiteUrl: map['websiteUrl'],
        )
    };
  }

  Future<int> update(Gift gift) {
    return database.update(
      'gifts',
      gift.toMap(),
      where: 'id = ?',
      // This prevents SQL injection.
      whereArgs: [gift.id],
    );
  }
}
