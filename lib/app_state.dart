import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './models/gift.dart';
import './models/occasion.dart';
import './models/person.dart';
import './services/database_service.dart';
import './services/gift_service.dart';
import './services/occasion_service.dart';
import './services/person_service.dart';

class AppState extends ChangeNotifier {
  // The first to hex characters in these colors are the opacity.
  static const defaultBackgroundColor = Color(0xff7affff); // blue
  static const defaultStartPageIndex = 0;
  static const defaultTitleColor = Color(0xffffffff); // white

  late SharedPreferences prefs;
  var _backgroundColor = defaultBackgroundColor;
  var _startPageIndex = defaultStartPageIndex;
  var _titleColor = defaultTitleColor;

  late GiftService _giftService;
  late OccasionService _occasionService;
  late PersonService _personService;

  var _gifts = <int, Gift>{};
  var _occasions = <int, Occasion>{};
  var _people = <int, Person>{};

  // These are used in gift_pickers.dart.
  var _selectedOccasionIndex = 0;
  var _selectedPersonIndex = 0;

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

  Color get backgroundColor => _backgroundColor;
  Map<int, Gift> get gifts => _gifts;
  Map<int, Occasion> get occasions => _occasions;
  Map<int, Person> get people => _people;
  Occasion? get selectedOccasion => _selectedOccasion;
  int get selectedOccasionIndex => _selectedOccasionIndex;
  Person? get selectedPerson => _selectedPerson;
  int get selectedPersonIndex => _selectedPersonIndex;
  int get startPageIndex => _startPageIndex;
  Color get titleColor => _titleColor;

  Future<void> addGift(Gift g) async {
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
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> addOccasion(Occasion o) async {
    if (o.name.isEmpty) return;
    try {
      await _occasionService.create(o);
      _occasions[o.id] = o;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> addPerson(Person p) async {
    if (p.name.isEmpty) return;
    try {
      await _personService.create(p);
      _people[p.id] = p;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> copyGift(Gift gift) async {
    final newGift = gift.clone;
    try {
      await _giftService.create(
        person: _selectedPerson!,
        occasion: _selectedOccasion!,
        gift: newGift,
      );
      await _setGifts();
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> deleteGift(Gift gift) async {
    try {
      await _giftService.delete(gift.id);
      _gifts.remove(gift.id);
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> deleteOccasion(Occasion o) async {
    try {
      await _occasionService.delete(o.id);
      _occasions.remove(o.id);
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> deletePerson(Person p) async {
    try {
      await _personService.delete(p.id);
      _people.remove(p.id);
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> _loadData() async {
    try {
      // Get preferences from SharedPreferences.
      prefs = await SharedPreferences.getInstance();
      int? color = prefs.getInt('backgroundColor');
      if (color != null) _backgroundColor = Color(color);
      var index = prefs.getInt('startPageIndex');
      if (index != null) _startPageIndex = index;
      color = prefs.getInt('titleColor');
      if (color != null) _titleColor = Color(color);

      _occasionService = DatabaseService.occasionService;
      _occasions = await _occasionService.getAll();
      if (_occasions.isNotEmpty) {
        _selectedOccasion = sortedOccasions[_selectedOccasionIndex];
      }

      _personService = DatabaseService.personService;
      _people = await _personService.getAll();
      if (_people.isNotEmpty) {
        _selectedPerson = sortedPeople[_selectedPersonIndex];
      }

      _giftService = DatabaseService.giftService;
      await _setGifts();

      isLoaded = true;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> moveGift(Gift gift) async {
    gift.occasionId = _selectedOccasion!.id;
    gift.personId = _selectedPerson!.id;
    try {
      await _giftService.update(gift);
      await _setGifts();
      notifyListeners();
      print('app_state.dart moveGift: finished move');
    } catch (e, s) {
      showError(e, s);
    }
  }

  void resetSettings() {
    backgroundColor = AppState.defaultBackgroundColor;
    startPageIndex = AppState.defaultStartPageIndex;
    titleColor = AppState.defaultTitleColor;
  }

  Future<void> selectOccasion(
    Occasion o, {
    required int index,
    bool silent = false,
  }) async {
    _selectedOccasion = o;
    _selectedOccasionIndex = index;
    if (_selectedPerson != null) _setGifts();
    if (!silent) notifyListeners();
  }

  Future<void> selectPerson(
    Person p, {
    required int index,
    bool silent = false,
  }) async {
    _selectedPerson = p;
    _selectedPersonIndex = index;
    if (_selectedOccasion != null) _setGifts();
    if (!silent) notifyListeners();
  }

  Future<void> _setGifts() async {
    if (_selectedPerson == null || _selectedOccasion == null) return;
    _gifts = await _giftService.get(
      person: _selectedPerson!,
      occasion: _selectedOccasion!,
    );
  }

  set backgroundColor(Color color) {
    prefs.setInt('backgroundColor', color.value);
    _backgroundColor = color;
    notifyListeners();
  }

  set startPageIndex(int index) {
    prefs.setInt('startPageIndex', index);
    _startPageIndex = index;
    notifyListeners();
  }

  set titleColor(Color color) {
    prefs.setInt('titleColor', color.value);
    _titleColor = color;
    notifyListeners();
  }

  void showError(error, stackTrace) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Data Setup Error'),
        content: Text('$error\n$stackTrace'),
      ),
    );
  }

  List<Occasion> get sortedOccasions {
    final list = _occasions.values.toList();
    list.sort((p1, p2) => p1.name.compareTo(p2.name));
    return list;
  }

  List<Person> get sortedPeople {
    final list = _people.values.toList();
    list.sort((p1, p2) => p1.name.compareTo(p2.name));
    return list;
  }

  Future<void> updateGift(Gift g) async {
    try {
      await _giftService.update(g);
      _gifts[g.id] = g;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> updateOccasion(Occasion o) async {
    try {
      await _occasionService.update(o);
      Occasion occasion = _occasions[o.id]!;
      occasion.name = o.name;
      occasion.date = o.date;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }

  Future<void> updatePerson(Person p) async {
    try {
      await _personService.update(p);
      Person person = _people[p.id]!;
      person.name = p.name;
      person.birthday = p.birthday;
      notifyListeners();
    } catch (e, s) {
      showError(e, s);
    }
  }
}
