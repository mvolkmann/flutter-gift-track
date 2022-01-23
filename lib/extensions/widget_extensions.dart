import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Container align([Alignment alignment = Alignment.centerLeft]) {
    return Container(alignment: alignment, child: this);
  }

  /// Wraps a widget in a Container that has a border.
  /// This is very useful for debugging.
  /// It is similar to the CSS property "outline: 1px solid red;".
  Container border({Color color = Colors.red}) {
    /*
    // This is an attempt to avoid nesting Containers in Containers.
    // It doesn't work because all the Container properties are final.
    var container =
        runtimeType == Container ? this as Container : Container(child: this);
    container.decoration = BoxDecoration(border: Border.all(color: color));
    return container;
    */
    return Container(
      child: this,
      decoration: BoxDecoration(border: Border.all(color: color)),
    );
  }

  /// Wraps a widget in a Center.
  Center get center => Center(child: this);

  /// Wraps a widget in a Center.
  Expanded get expand => Expanded(child: this);

  /// Wraps a widget in a Row which can prevent
  /// expanding the width to match the parent width.
  Row get row => Row(children: [this]);

  /// Wraps a widget in a SizedBox with a given width and height.
  SizedBox size({required double width, required double height}) {
    return SizedBox(child: this, height: height, width: width);
  }

  /// Wraps a widget in a Padding with a given horizontal padding.
  Padding hPad(double size) {
    return Padding(
        child: this, padding: EdgeInsets.symmetric(horizontal: size));
  }

  /// Wraps a widget in a Padding with given padding on all sides.
  Padding pad(double size) {
    return Padding(child: this, padding: EdgeInsets.all(size));
  }

  /// Wraps a widget in a Padding with a given horizontal padding.
  Padding vPad(double size) {
    return Padding(child: this, padding: EdgeInsets.symmetric(vertical: size));
  }
}

extension WidgetListExtension<Widget> on List<Widget> {
  /// Adds a SizedBox with a given width and no height
  /// between all Widgets in the List.
  List<Widget> hSpacing(double size) {
    for (int i = length - 1; i > 0; i--) {
      insert(i, SizedBox(width: size, height: 0) as Widget);
    }
    return this;
  }

  /*
  Row row() {
    //TODO: Why does the next line give the following error?
    //TODO: The argument type 'List<Widget>' can't be
    //TODO: assigned to the parameter type 'List<Widget>'
    return Row(children: this);
  }
  */

  /// Adds a SizedBox with the same width and height
  /// between all Widgets in the List.
  List<Widget> spacing(double size) {
    for (int i = length - 1; i > 0; i--) {
      insert(i, SizedBox(width: size, height: size) as Widget);
    }
    return this;
  }

  /// Adds a SizedBox with a given height and no width
  /// between all Widgets in the List.
  List<Widget> vSpacing(double size) {
    for (int i = length - 1; i > 0; i--) {
      insert(i, SizedBox(width: 0, height: size) as Widget);
    }
    return this;
  }
}
