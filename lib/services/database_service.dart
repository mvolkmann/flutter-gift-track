import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/gift.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../services/gift_service.dart';
import '../services/person_service.dart';
import '../services/occasion_service.dart';

class DatabaseService {
  static late GiftService giftService;
  static late OccasionService occasionService;
  static late PersonService personService;

  static var reset = true;

  static Future<void> setup() async {
    var db = await _getDatabase();
    giftService = GiftService(database: db);
    occasionService = OccasionService(database: db);
    personService = PersonService(database: db);
    if (reset) {
      await personService.deleteAll();
      await occasionService.deleteAll();
      //TODO: Maybe this isn't needed if gifts are deleted through cascades.
      //await giftService.deleteAll();

      await _createPeople();
      await _createOccasions();
      await _createGifts();
    }
  }

  static Future<void> _createGifts() async {
    _createGift(name: 'socks');
    _createGift(name: 'laptop', description: 'MacBook Pro');
  }

  static Future<void> _createOccasions() async {
    _createOccasion(name: 'Birthday');
    _createOccasion(name: 'Christmas', date: DateTime(0, 12, 25));
  }

  static Future<void> _createPeople() async {
    _createPerson(name: 'Mark', birthday: DateTime.utc(1961, 4, 16));
    _createPerson(name: 'Tami', birthday: DateTime.utc(1961, 9, 9));
  }

  static Future<Gift> _createGift({
    required String name,
    String? description,
  }) async {
    var gift = Gift(description: description, name: name);
    await giftService.create(gift);
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
      onCreate: (db, version) async {
        // This is only called if the database does not yet exist.
        reset = true;

        await db.execute('''
          create table gifts(
            id integer primary key autoincrement,
            date numeric,
            description text,
            imageUrl text,
            location text,
            name text,
            price integer,
            purchased numeric,
            websiteUrl text
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
      },
      // The version can be used to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
