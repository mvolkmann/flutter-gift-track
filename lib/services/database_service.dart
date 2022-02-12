import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/person.dart';
import '../services/person_service.dart';

class DatabaseService {
  var reset = false;
  late PersonService personService;
  var people = <Person>[];

  void setup() async {
    getDatabase().then((db) async {
      personService = PersonService(database: db);
      if (reset) {
        await personService.deleteAll();
        await _createPeople();
      }
      people = await personService.getAll();
      //setState(() {});
    });
  }

  Future<void> _createPeople() async {
    createPerson(name: 'Mark', birthday: DateTime.utc(1961, 4, 16));
  }

  Future<Person> createPerson({
    required String name,
    required DateTime birthday,
  }) async {
    var person = Person(birthday: birthday, name: name);
    await personService.create(person);
    return person;
  }

  Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'dog.db'),
      onCreate: (db, version) async {
        // This is only called if the database does not yet exist.
        reset = true;

        await db.execute('''
          create table gifts(
            id integer primary key autoincrement,
            date date,
            description text,
            imageUrl text,
            location text,
            name text,
            price int,
            purchased bool,
            websiteUrl text
          )
        ''');

        await db.execute('''
          create table occasions(
            id integer primary key autoincrement,
            date date,
            name text
          )
        ''');

        await db.execute('''
          create table people(
            id integer primary key autoincrement,
            irthday date,
            name text
          )
        ''');
      },
      // The version can be used to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
