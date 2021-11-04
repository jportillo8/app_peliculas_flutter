import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_flutter/helpers/debouncer.dart';
import 'package:peliculas_flutter/models/models.dart';
import 'package:peliculas_flutter/models/search_response.dart';

// El changeNotifier es como el chismoso el esta pendiente
// Es decir el que notifica que la informacion este alli.
class MoviesProvider extends ChangeNotifier {
  String _apiKey = 'b4d9fec6efcce29c0a8577a457f7e6dd';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayPopularMovies = [];

  // Este map es para añadir los actores a la app
  Map<int, List<Cast>> moviesCast = {};

  // Este int es para la pagina de las peliculas populares y poder hacer el
  // infity scroll
  int _popularPage = 0;

  // Usando el debouncer
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  // StreamController, a traves de este fluira una lista
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;
  // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

  MoviesProvider() {
    // print('MoviesProvider Inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  // LLamando la parte del HTTP
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPLayingRespose = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPLayingRespose.results;
    //Hey sucedio un cambio en la data redibujate
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final nowPopularResponse = PopularResponse.fromJson(jsonData);
    onDisplayPopularMovies = [
      ...onDisplayPopularMovies,
      ...nowPopularResponse.results
    ];
    notifyListeners();
  }

  //Peticion http para los actores
  Future<List<Cast>> getMovieCast(int movieId) async {
    // Para que no me haga la misma peticion y ahorrar datos entonces
    if (moviesCast.containsKey(movieId)) {
      return moviesCast[movieId]!;
    }

    // print('pidiendo info al servidor');
    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  // Peticion HTTP para el buscador
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

// Meter el valor del query cunando el debouncer emita un valor
// O cuando la persona deja de escribir
  void getsuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
