import 'package:flutteliculas/providers/movies_providers.dart';
import 'package:flutteliculas/search/search_delegate.dart';
import 'package:flutteliculas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartelera'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
           CardSwiper(movies: moviesProvider.onDisplayMovies),

           // Listado horizontal de peliculas
           MovieSlider(
             movies: moviesProvider.popularMovies,
             titleSlider: 'Pelis bien perronas',
             onNextPage: () => moviesProvider.getPopularMovies(),
           )
        ],
      ),
      )
    );
  }
}