import 'package:flutter/material.dart';
import 'package:poke_pairs/src/shared/classes/pokemon.dart';

class CardFront extends StatelessWidget {
  final Pokemon pokemon;

  const CardFront(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.orange[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
              child: pokemon.spirte,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
              child: Text(
                pokemon.name,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 9)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
