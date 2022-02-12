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
  var reset = false;
  late GiftService giftService;
  late OccasionService occasionService;
  late PersonService personService;
  var people = <Person>[];

  void setup() async {
    _getDatabase().then((db) async {
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
      people = await personService.getAll();
      //setState(() {});
    });
  }

  Future<void> _createGifts() async {
    _createGift(name: 'socks');
    _createGift(name: 'laptop', description: 'MacBook Pro');
  }

  Future<void> _createOccasions() async {
    _createOccasion(name: 'Birthday');
    _createOccasion(name: 'Christmas', date: DateTime(0, 12, 25));
  }

  Future<void> _createPeople() async {
    _createPerson(name: 'Mark', birthday: DateTime.utc(1961, 4, 16));
    _createPerson(name: 'Tami', birthday: DateTime.utc(1961, 9, 9));
  }

  Future<Gift> _createGift({
    required String name,
    String? description,
  }) async {
    var gift = Gift(description: description, name: name);
    await giftService.create(gift);
    return gift;
  }

  Future<Occasion> _createOccasion({
    required String name,
    DateTime? date,
  }) async {
    var occasion = Occasion(date: date, name: name);
    await occasionService.create(occasion);
    return occasion;
  }

  Future<Person> _createPerson({
    required String name,
    required DateTime birthday,
  }) async {
    var person = Person(birthday: birthday, name: name);
    await personService.create(person);
    return person;
  }

  Future<Database> _getDatabase() async {
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
            purchased bool,
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
