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
  
  MoviesProvider() {
    print('Movies provider inicializado');

    getOnDisplayMovies(); 
    getPopularMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseURL, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1'
    });


    final response = await http.get(url);
    final nowPlayingResponse = NowPlayResponse.fromJson(response.body);

    onDisplayMovies = nowPlayingResponse.results; 
    
    notifyListeners();
  }

  getPopularMovies() async {
    var url = Uri.https(_baseURL, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1'
    });


    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(response.body);

    popularMovies = [...popularMovies, ...popularResponse.results]; // mantiene las pelis en el array y le concatena las nuevas
    
    notifyListeners();
  }
}