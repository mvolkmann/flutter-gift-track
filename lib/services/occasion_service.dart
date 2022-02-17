import 'package:sqflite/sqflite.dart';
import '../models/occasion.dart';
import '../util.dart' show msToDateTime;

class OccasionService {
  final Database database;

  OccasionService({required this.database});

  Future<void> create(Occasion occasion) async {
    final map = occasion.toMap();
    // Removing the id allows the insert to assign an id.
    map.remove('id');
    final id = await database.insert('occasions', map);
    occasion.id = id;
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
