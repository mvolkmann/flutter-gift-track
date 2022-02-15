import 'package:flutter/cupertino.dart';

import './models/gift.dart';
import './models/occasion.dart';
import './models/person.dart';
import './services/database_service.dart';
import './services/occasion_service.dart';
import './services/person_service.dart';

class AppState extends ChangeNotifier {
  var _occasions = <int, Occasion>{};
  var _people = <int, Person>{};
  late OccasionService _occasionService;
  late PersonService _personService;
  BuildContext context;
  var isLoaded = false;

  AppState({required this.context}) {
    _loadData();
  }

  _loadData() async {
    try {
      await DatabaseService.setup();
      _occasionService = DatabaseService.occasionService;
      _occasions = await _occasionService.getAll();
      _personService = DatabaseService.personService;
      _people = await _personService.getAll();
      isLoaded = true;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
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
    try {
      await _occasionService.create(o);
      _occasions[o.id] = o;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  void addPerson(Person p) async {
    if (p.name.isEmpty) return;
    try {
      await _personService.create(p);
      _people[p.id] = p;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
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
    try {
      await _occasionService.delete(o.id);
      _occasions.remove(o);
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  void deletePerson(Person p) async {
    try {
      await _personService.delete(p.id);
      _people.remove(p.id);
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  void showError(error) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Data Setup Error'),
        content: Text('$error'),
      ),
    );
  }

  void updateOccasion(Occasion o) {
    try {
      _occasionService.update(o);
      Occasion occasion = _occasions[o.id]!;
      occasion.name = o.name;
      occasion.date = o.date;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  void updatePerson(Person p) {
    try {
      _personService.update(p);
      Person person = _people[p.id]!;
      person.name = p.name;
      person.birthday = p.birthday;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }
}
