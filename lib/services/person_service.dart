import 'package:sqflite/sqflite.dart';
import '../models/person.dart';

class PersonService {
  final Database database;

  PersonService({required this.database});

  Future<Person> create(Person person) async {
    var id = await database.insert(
      'people',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    person.id = id;
    return person;
  }

  Future<void> delete(int id) {
    return database.delete(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() {
    return database.delete('people');
  }

  Future<List<Person>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query('people');
    return List.generate(maps.length, (index) {
      var map = maps[index];
      return Person(
        birthday: map['birthday'],
        id: map['id'],
        name: map['name'],
      );
    });
  }

  Future<void> update(Person person) {
    return database.update(
      'people',
      person.toMap(),
      where: 'id = ?',
      // This prevents SQL injection.
      whereArgs: [person.id],
    );
  }
}
