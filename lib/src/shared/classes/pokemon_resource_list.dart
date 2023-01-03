import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonResourceList {
  final List<PokemonResourceListResult> results;

  PokemonResourceList({
    required this.results,
  });

  factory PokemonResourceList.fromMap(Map<String, dynamic> json) =>
      PokemonResourceList(
        results: (json["results"] as List)
            .map(
              (x) => PokemonResourceListResult.fromMap(x),
            )
            .toList(),
      );

  factory PokemonResourceList.fromJson(String str) =>
      PokemonResourceList.fromMap(
        jsonDecode(str),
      );

  static Future<PokemonResourceList> fetch() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10000'));

    if (response.statusCode == 200) {
      return PokemonResourceList.fromJson(response.body);
    }

    throw Exception('Failed to load pokemon resource list');
  }
}

class PokemonResourceListResult {
  final String url;

  PokemonResourceListResult({
    required this.url,
  });

  factory PokemonResourceListResult.fromMap(Map<String, dynamic> json) =>
      PokemonResourceListResult(
        url: json['url'].toString(),
      );
}
