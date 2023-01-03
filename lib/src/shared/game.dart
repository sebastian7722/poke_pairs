import 'package:flutter/material.dart';

import '../features/cards/view/cards_container.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const SafeArea(
            //Game content
            child: CardsContainer(),
          ),
        ],
      ),
    );
  }
}
