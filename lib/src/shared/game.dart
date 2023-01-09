import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poke_pairs/src/shared/classes/game_model.dart';
import 'package:provider/provider.dart';

import '../features/cards/view/cards_container.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GameModel>(context, listen: false);
    startTimer(provider: provider);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, value, child) {
        if (value.gameIsOver && _timer.isActive) {
          _timer.cancel();
        }

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
                                'Time: ${value.time}',
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
        );
      },
    );
  }

  void startTimer({required GameModel provider}) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (provider.time == 0) {
          _timer.cancel();
        }

        provider.decrementTime();
      },
    );
  }
}
