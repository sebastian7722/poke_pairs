import 'dart:convert';

import 'package:http/http.dart' as http;

class PokemonResource {
  final String name;
  final PokemonResourceSprites sprites;

  PokemonResource({
    required this.name,
    required this.sprites,
  });

  factory PokemonResource.fromJson(String str) => PokemonResource.fromMap(
        jsonDecode(str),
      );

  factory PokemonResource.fromMap(Map<String, dynamic> json) => PokemonResource(
        name: json['name'].toString(),
        sprites: PokemonResourceSprites.fromMap(json['sprites']),
      );

  static Future<PokemonResource> fetch({required String resourceUrl}) async {
    final response = await http.get(Uri.parse(resourceUrl));

    if (response.statusCode == 200) {
      return PokemonResource.fromJson(response.body);
    }

    throw Exception('Failed to load pokemon resource');
  }
}

class PokemonResourceSprites {
  final PokemonResourceSpriteOther other;

  PokemonResourceSprites({
    required this.other,
  });

  factory PokemonResourceSprites.fromMap(Map<String, dynamic> json) =>
      PokemonResourceSprites(
        other: PokemonResourceSpriteOther.fromMap(json['other']),
      );
}

class PokemonResourceSpriteOther {
  final PokemonResourceSpriteOtherOfficialArtwork officialArtwork;

  PokemonResourceSpriteOther({
    required this.officialArtwork,
  });

  factory PokemonResourceSpriteOther.fromMap(Map<String, dynamic> json) =>
      PokemonResourceSpriteOther(
        officialArtwork: PokemonResourceSpriteOtherOfficialArtwork.fromMap(
            json['official-artwork']),
      );
}

class PokemonResourceSpriteOtherOfficialArtwork {
  final String frontDefault;

  PokemonResourceSpriteOtherOfficialArtwork({
    required this.frontDefault,
  });

  factory PokemonResourceSpriteOtherOfficialArtwork.fromMap(
          Map<String, dynamic> json) =>
      PokemonResourceSpriteOtherOfficialArtwork(
        frontDefault: json['front_default'].toString(),
      );
}
