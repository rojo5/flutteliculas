import 'package:flutteliculas/models/models.dart';
import 'package:flutter/material.dart';

class MovieSlider extends StatelessWidget {

  final List<Movie> movies;
  final String? titleSlider;

  const MovieSlider({
    Key? key,
    required this.movies,
    this.titleSlider
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleSlider != null) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text( titleSlider!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),


          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
               itemCount: movies.length,
               itemBuilder: (_, int index) => _MoviePoster( movie: movies[index])
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {


  final Movie movie;

  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 130,
        height: 190,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'details', arguments: 'movie-instance'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20 ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ) 
          ],
        ),
      );
  }
}