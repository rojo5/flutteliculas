import 'dart:convert';

import 'package:flutteliculas/models/models.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http ;

class MoviesProvider  extends ChangeNotifier{

  String _apiKey = '85f637df6a4eb64ee38f4f1459d0d7e6';
  String _baseURL = 'api.themoviedb.org';
  String _language = 'es-ES';
  
  MoviesProvider() {
    print('Movies provider inicializado');

    getOnDisplayMovies(); 
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseURL, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1'
    });


    final response = await http.get(url);
    final nowPlayingResponse = NowPlayResponse.fromJson(response.body);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    print(nowPlayingResponse.results[0].title);
  }
}