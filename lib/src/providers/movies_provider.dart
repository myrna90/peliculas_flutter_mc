import 'dart:convert';

import 'package:peliculas_flutter/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apikey = '25fc49f046989dfbf92f78e8bb2800fa';
  String _url = 'api.themoviedb.org';
  String _language = 'es-US';

  Future<List<Movie>> getInCinemas() async {
    //este metodo regresa un future que hace la petición a mi servicio y retorna las peliculas
    //llamada a la url completa
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    //Aquí se hace una petición get a la url que acabamos de crear
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    //este constructor se encarga de barrer cada uno de los resultados y genera las peliculas y crea nuevas intancias de peliculas y los guarda aquí.
    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
}
