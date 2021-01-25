import 'dart:async';
import 'dart:convert';

import 'package:peliculas_flutter/src/models/actores_model.dart';
import 'package:peliculas_flutter/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apikey = '25fc49f046989dfbf92f78e8bb2800fa';
  String _url = 'api.themoviedb.org';
  String _language = 'es-US';
  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _populars = new List();

  /*codigo para crear un stream esto es un flujo de información el cual fluye en un solo sentido, entra la info el sink es para agregar,
  y pasa átraves del streamController, si se tiene que transformar se utiliza el streamTransform y sale 
  la información del stream en el mismo flujo en el cual entro los bloques ayudan a que se comuniquen 
  diferentes componentes de padres distintos y esto hace más amena la comunicación, cada que se utiliza un stream 
  se tiene que cerrar para que otro componente pueda acceder a la info o al stream.*/
  //Dentro del streamController se tiene que especificar que es lo que fluye por el en nuestro caso es una Lista de peliculas
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();
  //si no se pone el broadcast solo podria escuchar un solo elemento, se puede escuchar en muchos lugares

  //agrega
  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  //escucha
  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  //esto es para poder cerrar el stream y poder utilizarlo en otro lugar.
  void disposeStream() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processRespon(Uri url) async {
    //Aquí se hace una petición get a la url que acabamos de crear
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    //este constructor se encarga de barrer cada uno de los resultados y genera
    //las peliculas y crea nuevas intancias de peliculas y los guarda aquí.
    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getInCinemas() async {
    //este metodo regresa un future que hace la petición a mi servicio y retorna las peliculas
    //llamada a la url completa
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _processRespon(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_loading) return [];

    _loading = true;

    _popularsPage++;

    print('Cargando siguientes...');
    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final resp = await _processRespon(url);

    _populars.addAll(resp);

    popularsSink(_populars);

    _loading = false;
    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    //
    //aquí se crea el url
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apikey, 'language': _language});

    //se ejecuta el http de la url, el await me sirve para esperar la respuesta
    final resp = await http.get(url);

    //en el decodedData se almacena la respuesta del map
    final decodedData = json.decode(resp.body);

    //se manda el map en su propiedad cast
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Movie>> movieSearch(String query) async {
    //este metodo regresa un future que hace la petición a mi servicio y retorna las peliculas
    //llamada a la url completa
    final url = Uri.https(_url, '/3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _processRespon(url);
  }
}
