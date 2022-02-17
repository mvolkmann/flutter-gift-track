import 'package:flutter/cupertino.dart';

import './models/gift.dart';
import './models/occasion.dart';
import './models/person.dart';
import './services/database_service.dart';
import './services/gift_service.dart';
import './services/occasion_service.dart';
import './services/person_service.dart';

class AppState extends ChangeNotifier {
  late GiftService _giftService;
  late OccasionService _occasionService;
  late PersonService _personService;

  var _gifts = <int, Gift>{};
  var _occasions = <int, Occasion>{};
  var _people = <int, Person>{};

  BuildContext context;
  var isLoading = false;
  var isLoaded = false;
  Occasion? _selectedOccasion;
  Person? _selectedPerson;

  AppState({required this.context}) {
    if (!isLoading) {
      isLoading = true;
      _loadData();
    }
  }

  _loadData() async {
    try {
      _occasionService = DatabaseService.occasionService;
      _occasions = await _occasionService.getAll();
      _personService = DatabaseService.personService;
      _people = await _personService.getAll();
      _giftService = DatabaseService.giftService;
      isLoaded = true;
      notifyListeners();
    } catch (e) {
      showError(e);
    }
  }

  Map<int, Gift> get gifts => _gifts;
  Map<int, Occasion> get occasions => _occasions;
  Map<int, Person> get people => _people;
  Occasion? get selectedOccasion => _selectedOccasion;
  Person? get selectedPerson => _selectedPerson;

  void addGift(Gift g) async {
    if (g.name.isEmpty) return;

    if (_selectedPerson == null) {
      throw 'GiftService addGift requires a selected person.';
    }

    if (_selectedOccasion == null) {
      throw 'GiftService addGift requires a selected occasion.';
    }

    try {
      final gift = await _giftService.create(
        person: _selectedPerson!,
        occasion: _selectedOccasion!,
        gift: g,
      );
      _gifts[gift.id] = gift;
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
    _giftService.delete(gift.id);
    _gifts.remove(gift.id);
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

  Future<void> selectOccasion(Occasion o, {bool silent = false}) async {
    print('app_state.dart selectOccasion: o = $o');
    _selectedOccasion = o;
    if (_selectedPerson != null) {
      _gifts = await _giftService.get(
        person: _selectedPerson!,
        occasion: _selectedOccasion!,
      );
    }
    if (!silent) notifyListeners();
  }

  Future<void> selectPerson(Person p, {bool silent = false}) async {
    _selectedPerson = p;
    if (_selectedOccasion != null) {
      _gifts = await _giftService.get(
        person: _selectedPerson!,
        occasion: _selectedOccasion!,
      );
    }
    if (!silent) notifyListeners();
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
    print('app_state.dart updateGift: g = $g');
    try {
      _giftService.update(g);
      _gifts[g.id] = g;
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
