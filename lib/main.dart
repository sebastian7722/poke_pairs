import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poke_pairs/src/shared/classes/list_extension.dart';
import 'package:poke_pairs/src/shared/classes/pokemon.dart';
import 'package:poke_pairs/src/shared/classes/pokemon_loading.dart';
import 'package:poke_pairs/src/shared/classes/pokemon_resource_list.dart';
import 'package:poke_pairs/src/shared/classes/pokemon_resource.dart';
import 'package:provider/provider.dart';

import 'src/features/cards/view/cards_card.dart';
import 'src/features/cards/view/cards_card_front.dart';
import 'src/shared/classes/game_model.dart';
import 'src/shared/game.dart';
import 'src/shared/views/views.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => (GameModel()),
        child: const GameNavigation(),
      ),
    );
  }
}

class GameNavigation extends StatefulWidget {
  const GameNavigation({super.key});

  @override
  State<GameNavigation> createState() => _GameNavigationState();
}

class _GameNavigationState extends State<GameNavigation> {
  late Future<PokemonResourceList> futurePokemonUrls;

  @override
  void initState() {
    super.initState();
    futurePokemonUrls = PokemonResourceList.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonResourceList>(
      future: futurePokemonUrls,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loader();
        }

        void startHandler() {
          final viewModel = Provider.of<GameModel>(context, listen: false);
          final pokemonUrls = snapshot.data!.results.map((e) => e.url).toList();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                  value: viewModel,
                  child: GameResourceListLoader(pokemonUrls: pokemonUrls)),
            ),
          );
        }

        return Consumer<GameModel>(builder: (context, value, child) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (value.gameIsOver && Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          });

          return Menu(startHandler: startHandler);
        });
      },
    );
  }
}

class GameResourceListLoader extends StatefulWidget {
  final List<String> pokemonUrls;

  const GameResourceListLoader({
    required this.pokemonUrls,
    super.key,
  });

  @override
  State<GameResourceListLoader> createState() => _GameResourceListLoaderState();
}

class _GameResourceListLoaderState extends State<GameResourceListLoader> {
  List<PokemonResource>? _resources;

  int _getNextUniqueIndex(List<int> usedIndexes) {
    var random = widget.pokemonUrls.getRandomIndex().first;

    while (usedIndexes.contains(random)) {
      random = widget.pokemonUrls.getRandomIndex().first;
    }

    usedIndexes.add(random);

    return random;
  }

  Future<PokemonResource> _ensurePokemonImage(List<int> usedIndexes) async {
    final pokemonUrlIndex = _getNextUniqueIndex(usedIndexes);
    final url = widget.pokemonUrls[pokemonUrlIndex];

    final resource = await PokemonResource.fetch(resourceUrl: url);

    if (resource.sprites.other.officialArtwork.frontDefault == "null") {
      return await _ensurePokemonImage(usedIndexes);
    }

    return resource;
  }

  void _loadResources() async {
    setState(() {
      _resources = null;
    });

    final usedPokemonIndexes = widget.pokemonUrls.getRandomIndex(count: 8);
    final pokemonUrls =
        usedPokemonIndexes.map((e) => widget.pokemonUrls[e]).toList();

    final loadedResources = <PokemonResource>[];

    for (final url in pokemonUrls) {
      final resource = await PokemonResource.fetch(resourceUrl: url);

      if (resource.sprites.other.officialArtwork.frontDefault == "null") {
        final ensuredResource = await _ensurePokemonImage(
          usedPokemonIndexes,
        );
        loadedResources.add(ensuredResource);
        continue;
      }

      loadedResources.add(resource);
    }

    setState(() {
      _resources = loadedResources;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  @override
  Widget build(BuildContext context) {
    if (_resources == null) {
      return const Loader();
    }

    final pokemons = _resources!
        .map((e) => PokemonImageLoading(
              e.name,
              e.sprites.other.officialArtwork.frontDefault,
            ))
        .toList();

    return GameResourcesLoader(loadingPokemons: pokemons);
  }
}

class GameResourcesLoader extends StatelessWidget {
  final List<PokemonImageLoading> loadingPokemons;

  const GameResourcesLoader({
    required this.loadingPokemons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(loadingPokemons
          .map((e) => precacheImage(NetworkImage(e.spriteUrl), context))),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loader();
        }

        final loadedPokemons = loadingPokemons
            .map(
              (e) => Pokemon(
                name: e.name,
                spirte: Image.network(
                  e.spriteUrl,
                  fit: BoxFit.contain,
                ),
              ),
            )
            .toList();

        final pokemons = [...loadedPokemons, ...loadedPokemons]..shuffle();

        final cards = pokemons.asMap().entries.map((e) {
          final i = e.key;
          final val = e.value;
          return PokemonCard(
            id: i,
            cardBack: CardBack(pokemon: val),
            isScheduledForFlip: false,
            isFlipped: false,
            isFlippable: true,
            hasPair: false,
            onTap: (int id) {
              Provider.of<GameModel>(context, listen: false).flipCard(id);
            },
          );
        });

        Provider.of<GameModel>(context, listen: false).init(cards);

        return const Game();
      },
    );
  }
}
