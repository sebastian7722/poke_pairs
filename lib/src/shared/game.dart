import 'package:flutter/material.dart';
import 'package:poke_pairs/src/features/cards/view/cards_card_model.dart';
import 'package:provider/provider.dart';

import '../features/cards/view/cards_container.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    final time = 100;

    return Consumer<CardsModel>(
      builder: (context, value, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Container(
                //color: const Color.fromRGBO(0, 0, 0, 0.4),
                ),
            SafeArea(
              //Game content
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 16, right: 16, bottom: 0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Time: $time',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              'Flips: ${value.flips}',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: CardsContainer(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
