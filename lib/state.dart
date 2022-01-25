import 'package:flutter/material.dart';

class Person {
  String name;
  DateTime? birthday;

  Person({required this.name, this.birthday});
}

class AppState extends ChangeNotifier {
  var _adding = false;
  Person _person = Person(name: '');
  final _people = <Person>[];

  bool get adding => _adding;

  set adding(bool a) {
    _adding = a;
    notifyListeners();
  }

  void addPerson(Person p) {
    _people.add(p);
    notifyListeners();
  }

  void deletePerson(Person p) {
    _people.remove(p);
    notifyListeners();
  }

  List<Person> getPeople() {
    return _people;
  }

  Person? get person => _person;

  set person(Person? p) {
    _person = p;
    notifyListeners();
  }
}
