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
  late AppState appState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return Row(
      children: [
        buildPicker(
          items: appState.sortedPeople,
          selectedIndex: appState.selectedPersonIndex,
          title: 'Person',
        ),
        buildPicker(
          items: appState.sortedOccasions,
          selectedIndex: appState.selectedOccasionIndex,
          title: 'Occasion',
        ),
      ],
    );
  }

  Flexible buildPicker({
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
    //final titleStyle = CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    final titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    var index = selectedIndex;

    void selectItem() {
      final item = items[index];
      if (title == 'Person') {
        appState.selectPerson(item as Person, index: index);
      } else if (title == 'Occasion') {
        appState.selectOccasion(item as Occasion, index: index);
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
                // The function passed to Debounce cannot be anonymous
                // and cannot take arguments!
                // See https://github.com/mhrst/just_debounce_it/issues/4.
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
