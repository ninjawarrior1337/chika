import 'package:flutter/material.dart';

class TransparentMaterialPageRoute<T> extends MaterialPageRoute<T> {

  TransparentMaterialPageRoute({@required WidgetBuilder builder}) : super(builder: builder);

  @override
  bool get opaque => true;

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.transparent;
}