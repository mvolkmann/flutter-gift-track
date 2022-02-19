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
  static late GiftService giftService;
  static late OccasionService occasionService;
  static late PersonService personService;
  static late Occasion _firstOccasion;
  static late Person _firstPerson;

  // Set to true to recreate the database with initial data.
  static var reset = false;
  //static var reset = true;

  static Future<void> setup() async {
    var db = await _getDatabase();
    giftService = GiftService(database: db);
    occasionService = OccasionService(database: db);
    personService = PersonService(database: db);
    if (reset) {
      await _createTables(db);
      await _createPeople();
      await _createOccasions();
      await _createGifts();
    }
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

  static Future<void> _createOccasions() async {
    _firstOccasion = await _createOccasion(name: 'Birthday');
    await _createOccasion(name: 'Christmas', date: DateTime(0, 12, 25));
  }

  static Future<void> _createPeople() async {
    _firstPerson =
        await _createPerson(name: 'Mark', birthday: DateTime(1961, 4, 16));
    await _createPerson(name: 'Tami', birthday: DateTime(1961, 9, 9));
  }

  static Future<Gift> _createGift({
    required Person person,
    required Occasion occasion,
    required String name,
    String? description,
    int? price,
  }) async {
    var gift = Gift(description: description, name: name, price: price);
    await giftService.create(
      person: person,
      occasion: occasion,
      gift: gift,
    );
    return gift;
  }

  static Future<Occasion> _createOccasion({
    required String name,
    DateTime? date,
  }) async {
    var occasion = Occasion(date: date, name: name);
    await occasionService.create(occasion);
    return occasion;
  }

  static Future<Person> _createPerson({
    required String name,
    required DateTime birthday,
  }) async {
    var person = Person(birthday: birthday, name: name);
    await personService.create(person);
    return person;
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
      },
      onCreate: (db, version) async {
        // This is only called if the database does not yet exist.
        reset = true;
        _createTables(db);
      },
      // The version can be used to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static Future<void> _createTables(Database db) async {
    final tables = ['gifts', 'occasions', 'people'];
    for (var table in tables) {
      await db.execute('drop table if exists $table');
    }

    await db.execute('''
          create table gifts(
            id integer primary key autoincrement,
            date numeric,
            description text,
            imageUrl text,
            location text,
            name text,
            occasionId integer,
            personId integer,
            photo text,
            price integer,
            purchased numeric,
            websiteUrl text,
            foreign key(occasionId) references occasions(id),
            foreign key(personId) references people(id)
          )
        ''');
    await db.execute('''
          create table occasions(
            id integer primary key autoincrement,
            date numeric,
            name text
          )
        ''');
    await db.execute('''
          create table people(
            id integer primary key autoincrement,
            birthday numeric,
            name text
          )
        ''');
  }
}
