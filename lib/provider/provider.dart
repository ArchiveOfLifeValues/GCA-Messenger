import 'package:flutter/material.dart';

class Provider<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const Provider({
    Key? key,
    required T notifier,
    required Widget child,
  }) : super(
          key: key,
          notifier: notifier,
          child: child,
        );

  static T? follow<T extends ChangeNotifier>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<T>>()?.notifier;
  }

  static T? read<T extends ChangeNotifier>(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<Provider<T>>()?.widget;
    return widget is Provider<T> ? widget.notifier : null;
  }
}