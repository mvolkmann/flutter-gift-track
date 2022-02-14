import 'package:flutter/material.dart';

import './models/gift.dart';
import './models/occasion.dart';
import './models/person.dart';
import './services/database_service.dart';

class AppState extends ChangeNotifier {
  var _occasions = <int, Occasion>{};
  var _people = <int, Person>{};

  AppState() {
    _loadData();
  }

  _loadData() async {
    await DatabaseService.setup();
    _people = await DatabaseService.personService.getAll();
    _occasions = await DatabaseService.occasionService.getAll();
  }

  Map<int, Occasion> get occasions => _occasions;

  Map<int, Person> get people => _people;

  void addGift({
    required Person person,
    required Occasion occasion,
    required Gift gift,
  }) {
    person.addGift(occasion: occasion, gift: gift);
    notifyListeners();
  }

  void addOccasion(Occasion o) async {
    if (o.name.isEmpty) return;
    await DatabaseService.occasionService.create(o);
    _occasions[o.id] = o;
    notifyListeners();
  }

  void addPerson(Person p) async {
    if (p.name.isEmpty) return;
    await DatabaseService.personService.create(p);
    _people[p.id] = p;
    notifyListeners();
  }

  void deleteGift({
    required Person person,
    required Occasion occasion,
    required Gift gift,
  }) {
    person.deleteGift(occasion: occasion, gift: gift);
    notifyListeners();
  }

  void deleteOccasion(Occasion o) async {
    await DatabaseService.occasionService.delete(o.id);
    _occasions.remove(o);
    notifyListeners();
  }

  void deletePerson(Person p) async {
    await DatabaseService.personService.delete(p.id);
    _people.remove(p.id);
    notifyListeners();
  }

  void updatePerson(Person p) {
    DatabaseService.personService.update(p);
    Person person = _people[p.id]!;
    person.name = p.name;
    person.birthday = p.birthday;
    notifyListeners();
  }
}
