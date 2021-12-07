import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors
import 'package:flutter/widgets.dart';

class DebugBorder extends StatelessWidget {
  final Widget child;
  const DebugBorder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: child);
  }
}

extension DebugExtension on Widget {
  Widget get debugBorder {
    return DebugBorder(child: this);
  }
}
