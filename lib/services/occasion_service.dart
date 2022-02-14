import 'package:sqflite/sqflite.dart';
import '../models/occasion.dart';
import '../util.dart' show msToDateTime;

class OccasionService {
  final Database database;

  OccasionService({required this.database});

  Future<Occasion> create(Occasion occasion) async {
    final id = await database.insert(
      'occasions',
      occasion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    occasion.id = id;
    return occasion;
  }

  Future<void> delete(int id) {
    //TODO: Need cascading delete of gifts.
    return database.delete(
      'occasions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() {
    //TODO: Need cascading delete of gifts.
    return database.delete('occasions');
  }

  Future<Map<int, Occasion>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query('occasions');
    return <int, Occasion>{
      for (var map in maps)
        map['id']: Occasion(
          date: msToDateTime(map['date']),
          id: map['id'],
          name: map['name'],
        )
    };
  }

  Future<void> update(Occasion occasion) {
    return database.update(
      'occasions',
      occasion.toMap(),
      where: 'id = ?',
      // This prevents SQL injection.
      whereArgs: [occasion.id],
    );
  }
}
