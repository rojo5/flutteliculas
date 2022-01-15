import 'dart:async';
import 'dart:convert';

import 'package:flutteliculas/helpers/debouncer.dart';
import 'package:flutteliculas/models/models.dart';
import 'package:flutteliculas/models/search_response.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http ;

class MoviesProvider  extends ChangeNotifier{

  String _apiKey = '85f637df6a4eb64ee38f4f1459d0d7e6';
  String _baseURL = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500), 
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;
   
  
  MoviesProvider() {
    print('Movies provider inicializado');

    getOnDisplayMovies(); 
    getPopularMovies();
  }

  Future<String> _getJSONData(String endpoint, [int page = 1]) async{
    final url = Uri.https(_baseURL, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJSONData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results; 
    
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;

    final jsonData = await _getJSONData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results]; // mantiene las pelis en el array y le concatena las nuevas
    
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if (moviesCast.containsKey(movieId))  return moviesCast[movieId]!;

    final jsonData = await _getJSONData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }


   Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseURL, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson(response.body);

      return searchResponse.results;
  }


  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value  = '';
    debouncer.onValue = (value) async {
      print('Tenemos valor : $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
     });

     Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}