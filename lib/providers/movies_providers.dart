import 'dart:convert';

import 'package:flutteliculas/models/models.dart';
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
  
  MoviesProvider() {
    print('Movies provider inicializado');

    getOnDisplayMovies(); 
    getPopularMovies();
  }

  Future<String> _getJSONData(String endpoint, [int page = 1]) async{
    var url = Uri.https(_baseURL, endpoint, {
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
}