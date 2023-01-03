import 'package:flutter/material.dart' hide Card;
import 'package:poke_pairs/src/features/cards/view/cards_card_model.dart';
import 'package:provider/provider.dart';

class CardsContainer extends StatelessWidget {
  const CardsContainer({super.key});

  final double _gridSpacing = 6;

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsModel>(
      builder: (context, state, child) => GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: _gridSpacing,
        mainAxisSpacing: _gridSpacing,
        childAspectRatio: 0.73879310344827586206896551724138,
        padding: const EdgeInsets.all(16),
        children: state.items,
      ),
    );
  }
}
