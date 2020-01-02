import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/abstract_provider.dart';

class PeliculasProvider extends AbstractProvider{

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popuparesStream => _popularesStreamController.stream;


  void disposeStreams() {
    _popularesStreamController?.close();
  }

  /// Obtiene las películas actuales en cines
  Future<List<Pelicula>> getEnCines() async {
    final uri = Uri.https(url, '3/movie/now_playing', {
      'api_key': apiKey,
      'language': language
    });

    return await _procesarRespuesta( uri );
  }

  /// Obtiene las películas populares
  Future<List<Pelicula>> getPopulares() async {

    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final uri = Uri.https(url, '3/movie/popular', {
      'api_key': apiKey,
      'language': language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta( uri );

    _populares.addAll( resp );
    popularesSink( _populares );

    return resp;
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {

    final resp = await http.get( url );
    final decodedData = json.decode( resp.body );

    final peliculas = new Peliculas.fromJsonList( decodedData['results'] );

    _cargando = false;

    return peliculas.items;
  }

}
