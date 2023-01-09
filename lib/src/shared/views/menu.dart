import 'package:flutter/material.dart';
import 'package:poke_pairs/src/shared/classes/game_model.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  final VoidCallback startHandler;

  const Menu({
    required this.startHandler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Consumer<GameModel>(
            builder: (context, value, child) {
              const title = Align(
                alignment: Alignment.center,
                child: Text(
                  "PokePairs",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w800),
                ),
              );

              final subTitle = Align(
                alignment: Alignment.center,
                child: Text(
                  value.gameResult ?? "",
                  style: TextStyle(
                    color: value.gameResult == "VICTORY"
                        ? Colors.green[400]
                        : Colors.red[400],
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );

              final startBtn = OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(width: 3.0, color: Colors.amber),
                    foregroundColor: Colors.amber),
                onPressed: startHandler,
                child: const Text('Start'),
              );

              final settingsButton = OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(width: 3.0, color: Colors.white),
                    foregroundColor: Colors.white),
                onPressed: () {},
                child: const Text('Settings'),
              );

              final aboutButton = OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(width: 3.0, color: Colors.white),
                    foregroundColor: Colors.white),
                onPressed: () {},
                child: const Text('About'),
              );

              final buttons = FractionallySizedBox(
                widthFactor: 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    startBtn,
                    const SizedBox(height: 10),
                    settingsButton,
                    const SizedBox(height: 10),
                    aboutButton,
                  ],
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: value.gameResult == null
                    ? [title, buttons]
                    : [title, subTitle, buttons],
              );
            },
          ),
        ),
      ),
    );
  }
}
