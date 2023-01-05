import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'cards_card.dart';

class CardsModel extends ChangeNotifier {
  final List<Card> _items = [];
  var _flips = 0;

  UnmodifiableListView<Card> get items => UnmodifiableListView(_items);
  int get flips => _flips;

  void initCards(Iterable<Card> cards) {
    _items.clear();
    _items.addAll(cards);
  }

  List<Card> _getPossiblePairs() {
    return _items.where((card) => card.isFlipped && !card.hasPair).toList();
  }

  void _restoreFlipOnNonPairCards() {
    final restoredCards =
        _items.where((element) => !element.hasPair).map((e) => Card(
              id: e.id,
              cardFront: e.cardFront,
              isFlipped: false,
              isFlippable: true,
              hasPair: e.hasPair,
              onTap: e.onTap,
            ));

    for (var element in restoredCards) {
      final elementIndex = _items.indexWhere((y) => y.id == element.id);
      _items[elementIndex] = element;
    }
  }

  void flipCard(int id) {
    final cardIndex = _items.indexWhere((element) => element.id == id);
    final card = _items[cardIndex];
    if (!card.isFlippable || card.hasPair) return;

    final updatedCard = Card(
      id: card.id,
      cardFront: card.cardFront,
      isFlippable: false,
      isFlipped: true,
      hasPair: card.hasPair,
      onTap: card.onTap,
    );
    _items[cardIndex] = updatedCard;

    if (_getPossiblePairs().length == 2) {
      final newCards = _items
          .map((e) => Card(
              id: e.id,
              cardFront: e.cardFront,
              isFlipped: e.isFlipped,
              isFlippable: false,
              hasPair: e.hasPair,
              onTap: e.onTap))
          .toList();

      _items.clear();
      _items.addAll(newCards);
    }

    notifyListeners();
  }

  void flipToFrontDone() {
    print('flipped to front');
    final possiblePair = _getPossiblePairs();
    if (possiblePair.length != 2) return;

    if (possiblePair[0].cardFront.pokemon.name ==
        possiblePair[1].cardFront.pokemon.name) {
      final updatedFirstCardIndex =
          _items.indexWhere((element) => element.id == possiblePair[0].id);
      final updatedFirstCard = Card(
        id: possiblePair[0].id,
        cardFront: possiblePair[0].cardFront,
        isFlippable: possiblePair[0].isFlippable,
        isFlipped: possiblePair[0].isFlipped,
        hasPair: true,
        onTap: possiblePair[0].onTap,
      );
      final updatedSecondCardIndex =
          _items.indexWhere((element) => element.id == possiblePair[1].id);
      final updatedSecondCard = Card(
        id: possiblePair[1].id,
        cardFront: possiblePair[1].cardFront,
        isFlippable: possiblePair[1].isFlippable,
        isFlipped: possiblePair[1].isFlipped,
        hasPair: true,
        onTap: possiblePair[1].onTap,
      );

      _items[updatedFirstCardIndex] = updatedFirstCard;
      _items[updatedSecondCardIndex] = updatedSecondCard;
    }

    _restoreFlipOnNonPairCards();

    _flips++;
    notifyListeners();
  }
}
