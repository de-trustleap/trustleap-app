import 'package:flutter/material.dart';

class AnimatedListDiffer<T> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final bool Function(T a, T b) isSame;
  final Duration duration;
  late List<T> _displayedList;

  AnimatedListDiffer({
    required List<T> initialList,
    required this.isSame,
    this.duration = const Duration(milliseconds: 300),
  }) : _displayedList = List.from(initialList);

  List<T> get items => _displayedList;

  void update({
    required List<T> newList,
    required Widget Function(T item, Animation<double> animation) buildRemovedItem,
  }) {
    for (var i = _displayedList.length - 1; i >= 0; i--) {
      final item = _displayedList[i];
      if (!newList.any((n) => isSame(n, item))) {
        final removed = _displayedList.removeAt(i);
        listKey.currentState?.removeItem(
          i,
          (context, animation) => buildRemovedItem(removed, animation),
          duration: duration,
        );
      }
    }

    for (var i = 0; i < newList.length; i++) {
      if (!_displayedList.any((d) => isSame(d, newList[i]))) {
        _displayedList.insert(i, newList[i]);
        listKey.currentState?.insertItem(i, duration: duration);
      }
    }
  }
}
