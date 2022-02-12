import 'package:sqflite/sqflite.dart';
import '../models/gift.dart';
import '../util.dart' show msToDateTime;

class GiftService {
  final Database database;

  GiftService({required this.database});

  Future<Gift> create(Gift gift) async {
    var id = await database.insert(
      'gifts',
      gift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    gift.id = id;
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

  Future<List<Gift>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query('gifts');
    return List.generate(maps.length, (index) {
      var map = maps[index];
      return Gift(
        date: msToDateTime(map['date']),
        description: map['description'],
        id: map['id'],
        imageUrl: map['imageUrl'],
        location: map['location'],
        name: map['name'],
        price: map['price'],
        //purchased: map['purchased'],
        websiteUrl: map['websiteUrl'],
      );
    });
  }

  Future<void> update(Gift gift) {
    return database.update(
      'gifts',
      gift.toMap(),
      where: 'id = ?',
      // This prevents SQL injection.
      whereArgs: [gift.id],
    );
  }
}
