
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/providers/abstract_provider.dart';

class CastProvider extends AbstractProvider {

  List<Actor> _actores = new List();

  Future<List<Actor>> getCast(int idPelicula) async {

    final uri = Uri.https(url, '3/movie/$idPelicula/credits', {
      'api_key': apiKey,
      'language': language
    });

    final resp = await http.get( uri );
    final decodedData = json.decode( resp.body );

    final _cast = new Cast.fromJsonList( decodedData['cast'] );

    return _cast.actores;
  }
}
