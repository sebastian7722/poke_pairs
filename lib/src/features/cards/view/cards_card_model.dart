import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'cards_card.dart';

class CardsModel extends ChangeNotifier {
  final List<PokemonCard> _items = [];
  var _flips = 0;

  UnmodifiableListView<PokemonCard> get items => UnmodifiableListView(_items);
  int get flips => _flips;

  void initCards(Iterable<PokemonCard> cards) {
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
      _items[firstIndex] = _items[firstIndex].copyWith(isFlipped: false);
      _items[secondIndex] = _items[secondIndex].copyWith(isFlipped: false);
    }

    _flips++;
    notifyListeners();
  }
}
