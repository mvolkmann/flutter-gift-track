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

  void addGift(Gift g) async {
    print('app_state.dart addGift: entered');
    if (g.name.isEmpty) return;
    try {
      //person.addGift(occasion: occasion, gift: gift);
      //await _giftService.create(g);
      //_gifts[g.id] = g;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
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

  void deleteGift(Gift gift) {
    print('app_state.dart deleteGift: entered');
    //person.deleteGift(occasion: occasion, gift: gift);
    notifyListeners();
  }

  Future<void> deleteOccasion(Occasion o) async {
    try {
      await _occasionService.delete(o.id);
      _occasions.remove(o.id);
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  Future<void> deletePerson(Person p) async {
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

  void updateGift(Gift g) {
    try {
      //_giftService.update(g);
      //Gift gift = _gifts[g.id]!;
      //gift.name = g.name;
      //gift.purchased = g.purchased;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
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
