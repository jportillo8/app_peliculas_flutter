import 'package:flutter/material.dart';
import 'package:peliculas_flutter/providers/movies_provider.dart';
import 'package:peliculas_flutter/search/search_delegate.dart';
import 'package:peliculas_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ve al arbol de widgets traeme la instacia de MoviesProvider y colocala en la variable
    // Tambien tiene un listen: true con el objetivo de redibujarse
    final moviesProvider = Provider.of<MoviesProvider>(context);
    // print(popularMoviesProvider.onDisplayPopularMovies);

    // print(moviesProvider.onDisplayMovies);

    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en cines'),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search_outlined),
              // Implementacion del buscador
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            // Tarjetas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            // Slider de Peliculas
            MovieSlider(
              moviesPopulares: moviesProvider.onDisplayPopularMovies,
              title: 'Populares',
              onNextPage: () {
                moviesProvider.getPopularMovies();
                // print('hey!!');
              },
            ),
          ],
        )));
  }
}
