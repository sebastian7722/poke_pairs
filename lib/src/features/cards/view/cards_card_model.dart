import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'cards_card.dart';

class CardsModel extends ChangeNotifier {
  final List<Card> _items = [];

  List<Card> get items => UnmodifiableListView(_items);

  void initCards(Iterable<Card> cards) {
    _items.clear();
    _items.addAll(cards);
  }

  void updateValue(int id) {
    final changedCardIndex = _items.indexWhere((element) => element.id == id);
    final changedCard = _items[changedCardIndex];
    final updatedCard = Card(
      id: changedCard.id,
      cardFront: changedCard.cardFront,
      isFlippable: changedCard.isFlippable,
      isflipped: !changedCard.isflipped,
      onTap: changedCard.onTap,
    );

    _items[changedCardIndex] = updatedCard;
    notifyListeners();
  }
}
