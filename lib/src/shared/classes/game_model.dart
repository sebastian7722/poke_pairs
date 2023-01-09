import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../features/cards/view/cards_card.dart';

class GameModel extends ChangeNotifier {
  final List<PokemonCard> _items = [];
  var _gameIsOver = false;
  String? _gameResult;
  late int _time;
  late int _flips;

  UnmodifiableListView<PokemonCard> get items => UnmodifiableListView(_items);
  int get time => _time;
  int get flips => _flips;
  bool get gameIsOver => _gameIsOver;
  String? get gameResult => _gameResult;

  void init(Iterable<PokemonCard> cards) {
    _gameIsOver = false;
    _gameResult = null;
    _time = 60;
    _flips = 0;
    _items.clear();
    _items.addAll(cards);
  }

  void flipCard(int id) {
    final cardIndex = _items.indexWhere((element) => element.id == id);
    if (!_items[cardIndex].isFlippable || _items[cardIndex].hasPair) return;

    for (var i = 0; i < _items.length; i++) {
      if (cardIndex == i) {
        _items[i] = _items[i].copyWith(
          isScheduledForFlip: true,
          isFlippable: false,
          isFlipped: true,
        );
        continue;
      }

      _items[i] = _items[i].copyWith(isFlippable: false);
    }

    notifyListeners();
  }

  void flipToBackDone() {
    final cardIndex =
        _items.indexWhere((element) => element.isScheduledForFlip);

    for (var i = 0; i < _items.length; i++) {
      if (cardIndex == i) {
        _items[i] = _items[i].copyWith(
          isScheduledForFlip: false,
        );
        continue;
      }

      _items[i] = _items[i].copyWith(isFlippable: true);
    }

    final possiblePair = _items
        .where((element) => !element.hasPair && element.isFlipped)
        .toList();
    if (possiblePair.length != 2) return;
    final firstIndex =
        _items.indexWhere((element) => element.id == possiblePair[0].id);
    final secondIndex =
        _items.indexWhere((element) => element.id == possiblePair[1].id);
    if (possiblePair[0].cardBack.pokemon.name ==
        possiblePair[1].cardBack.pokemon.name) {
      _items[firstIndex] = _items[firstIndex].copyWith(hasPair: true);
      _items[secondIndex] = _items[secondIndex].copyWith(hasPair: true);
    } else {
      _items[firstIndex] =
          _items[firstIndex].copyWith(isFlipped: false, isFlippable: true);
      _items[secondIndex] =
          _items[secondIndex].copyWith(isFlipped: false, isFlippable: true);
    }

    _flips++;
    notifyListeners();

    if (_items.every((element) => element.hasPair)) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        if (_gameIsOver) return;
        _gameIsOver = true;
        _gameResult = "VICTORY";
        notifyListeners();
      });
    }
  }

  decrementTime() {
    if (_time == 0) {
      _gameIsOver = true;
      _gameResult = "DEFEATED";
    } else {
      _time--;
    }

    notifyListeners();
  }
}
