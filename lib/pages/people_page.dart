import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors
import 'package:flutter/widgets.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('People'),
        ],
      ),
    );
  }
}
