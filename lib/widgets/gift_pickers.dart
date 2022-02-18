import 'package:flutter/cupertino.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/named.dart';
import '../models/occasion.dart';
import '../models/person.dart';

class GiftPickers extends StatefulWidget {
  const GiftPickers({
    Key? key,
  }) : super(key: key);

  @override
  State<GiftPickers> createState() => _GiftPickersState();
}

class _GiftPickersState extends State<GiftPickers> {
  late AppState _appState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);

    return Row(
      children: [
        _buildPicker(
          items: _appState.sortedPeople,
          selectedIndex: _appState.selectedPersonIndex,
          title: 'Person',
        ),
        _buildPicker(
          items: _appState.sortedOccasions,
          selectedIndex: _appState.selectedOccasionIndex,
          title: 'Occasion',
        ),
      ],
    );
  }

  Flexible _buildPicker({
    required String title,
    required List<Named> items,
    required int selectedIndex,
  }) {
    const itemHeight = 30.0;
    const pickerHeight = 150.0;
    final decoration = BoxDecoration(
      border: Border.all(color: CupertinoColors.lightBackgroundGray),
    );
    final scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);
    //var titleStyle = CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    var titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    var index = selectedIndex;
    void selectItem() {
      final item = items[index];
      if (title == 'Person') {
        _appState.selectPerson(item as Person, index: index);
      } else if (title == 'Occasion') {
        _appState.selectOccasion(item as Occasion, index: index);
      }
    }

    return Flexible(
      child: Column(
        children: [
          Text(title, style: titleStyle),
          Container(
            child: CupertinoPicker.builder(
              childCount: items.length,
              itemBuilder: (_, index) => Text(items[index].name),
              itemExtent: itemHeight,
              onSelectedItemChanged: (i) {
                index = i;
                Debounce.milliseconds(500, selectItem);
              },
              scrollController: scrollController,
            ),
            decoration: decoration,
            height: pickerHeight,
          ),
        ],
      ),
    );
  }
}
