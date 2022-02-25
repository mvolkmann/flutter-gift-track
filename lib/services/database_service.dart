import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/gift.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../services/gift_service.dart';
import '../services/person_service.dart';
import '../services/occasion_service.dart';

// This should ONLY be used in app_state.dart!
class DatabaseService {
  // Set to true to recreate the database with initial data.
  static var reset = false;
  //static var reset = true;

  static late GiftService giftService;
  static late OccasionService occasionService;
  static late PersonService personService;
  static late Occasion _firstOccasion;
  static late Person _firstPerson;

  static Future<void> setup() async {
    final db = await _getDatabase();
    giftService = GiftService(database: db);
    occasionService = OccasionService(database: db);
    personService = PersonService(database: db);
    await _createTables(db);
  }

  static Future<Gift> _createGift({
    required Person person,
    required Occasion occasion,
    required String name,
    String? description,
    int? price,
  }) async {
    final gift = Gift(description: description, name: name, price: price);
    await giftService.create(
      person: person,
      occasion: occasion,
      gift: gift,
    );
    return gift;
  }

  static Future<void> _createGifts() async {
    await _createGift(
      person: _firstPerson,
      occasion: _firstOccasion,
      name: 'socks',
      price: 10,
    );
    await _createGift(
      person: _firstPerson,
      occasion: _firstOccasion,
      name: 'book',
      description: 'The Hobbit',
    );
    await _createGift(
      person: _firstPerson,
      occasion: _firstOccasion,
      name: 'laptop',
      description: 'MacBook Pro',
      price: 3000,
    );
  }

  static Future<Occasion> _createOccasion({
    required String name,
    DateTime? date,
  }) async {
    final occasion = Occasion(date: date, name: name);
    await occasionService.create(occasion);
    return occasion;
  }

  static Future<void> _createOccasions() async {
    _firstOccasion = await _createOccasion(name: 'Birthday');
    await _createOccasion(name: 'Christmas', date: DateTime(0, 12, 25));
    await _createOccasion(name: 'Father\'s Day');
    await _createOccasion(name: 'Mother\'s Day');
  }

  static Future<void> _createPeople() async {
    _firstPerson =
        await _createPerson(name: 'Amanda', birthday: DateTime(1985, 7, 22));
    await _createPerson(name: 'Mark', birthday: DateTime(1961, 4, 16));
    await _createPerson(name: 'Tami', birthday: DateTime(1961, 9, 9));
    await _createPerson(name: 'Jeremy', birthday: DateTime(1987, 4, 30));
  }

  static Future<Person> _createPerson({
    required String name,
    required DateTime birthday,
  }) async {
    final person = Person(birthday: birthday, name: name);
    await personService.create(person);
    return person;
  }

  static Future<void> _createTables(Database db) async {
    if (!await _tableExists(db, 'people')) {
      print('database_service.dart _createTables: creating people table');
      await db.execute('''
          create table if not exists people(
            id integer primary key autoincrement,
            birthday numeric,
            name text
          )
        ''');
      await _createPeople();
    }

    if (!await _tableExists(db, 'occasions')) {
      print('database_service.dart _createTables: creating occasions table');
      await db.execute('''
          create table if not exists occasions(
            id integer primary key autoincrement,
            date numeric,
            name text
          )
        ''');
      await _createOccasions();
    }

    if (!await _tableExists(db, 'gifts')) {
      print('database_service.dart _createTables: creating gifts table');
      await db.execute('''
          create table if not exists gifts(
            id integer primary key autoincrement,
            date numeric,
            description text,
            imageUrl text,
            latitude real,
            location text,
            longitude real,
            name text,
            occasionId integer,
            personId integer,
            photo text,
            price integer,
            purchased numeric,
            websiteUrl text,
            zoom real,
            foreign key(occasionId) references occasions(id),
            foreign key(personId) references people(id)
          )
        ''');
      await _createGifts();
    }
  }

  static Future<Database> _getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'dog.db'),
      onConfigure: (db) async {
        if (reset) {
          final tables = ['gifts', 'occasions', 'people'];
          for (var table in tables) {
            await db.execute('drop table if exists $table');
          }
        }
        await setup();
      },
      /*
      onCreate: (db, version) async {
        _createTables(db);
      },
      */
      // The version can be used to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static Future<bool> _tableExists(Database db, String tableName) async {
    final result = await db.query(
      'sqlite_master',
      where: 'name = ?',
      whereArgs: [tableName],
    );
    return result.isNotEmpty;
  }
}
