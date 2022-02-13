import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import './my_page.dart';
import './person_page.dart';
import '../models/person.dart';
import '../state.dart';
import '../util.dart' show formatDate;
import '../widgets/my_text.dart';
import '../widgets/my_text_button.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatelessWidget {
  static const route = '/people';

  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'People',
      child: _buildBody(context),
      trailing: MyTextButton(
        text: 'Add',
        onPressed: () {
          Navigator.pushNamed(context, PersonPage.route);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var people = appState.people;
    print('people_page.dart _buildBody: people = $people');

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text('People Count: ${people.length}'),
            Expanded(
              child: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  var person = people[index];
                  return CupertinoListTile(
                    //border: Border.all(color: Colors.green),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _edit(context, person),
                    title: MyText(person.name),
                    subtitle: person.birthday == null
                        ? null
                        : MyText(
                            formatDate(person.birthday!),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _edit(BuildContext context, Person person) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PersonPage(person: person),
      ),
    );
  }
}
