import 'package:sqflite/sqflite.dart';
import '../models/person.dart';
import '../util.dart' show msToDateTime;

class PersonService {
  final Database database;

  PersonService({required this.database});

  Future<void> create(Person person) async {
    final map = person.toMap();
    // Removing the id allows the insert to assign an id.
    map.remove('id');
    final id = await database.insert('people', map);
    person.id = id;
  }

  Future<void> delete(int id) {
    //TODO: Need cascading delete of gifts.
    return database.delete(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() {
    //TODO: Need cascading delete of gifts.
    return database.delete('people');
  }

  Future<Map<int, Person>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query('people');
    return <int, Person>{
      for (var map in maps)
        map['id']: Person(
          birthday: msToDateTime(map['birthday']),
          id: map['id'],
          name: map['name'],
        )
    };
  }

  Future<int> update(Person person) {
    return database.update(
      'people',
      person.toMap(),
      where: 'id = ?',
      // This prevents SQL injection.
      whereArgs: [person.id],
    );
  }
}
