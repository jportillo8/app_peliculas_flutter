import 'package:flutter/material.dart';
import 'package:peliculas_flutter/models/models.dart';
import 'package:peliculas_flutter/providers/movies_provider.dart';
import 'package:provider/provider.dart';
// Implementacion del buscador

class MovieSearchDelegate extends SearchDelegate {
  // cambio de idioma
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(Icons.movie_creation_outlined,
            color: Colors.black38, size: 120),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    // print('http request');
    // En false por que no quiero se la pase redibu
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    // Para mostrar los resultados del stream
    // Esto se mandara a llamar cada vez que la persona toque una tecla
    moviesProvider.getsuggestionByQuery(query);

    // return FutureBuilder(
    //   future: moviesProvider.searchMovies(query),
    //   builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
    //     if (!snapshot.hasData) return _emptyContainer();
    //     final movies = snapshot.data!;
    //     return ListView.builder(
    //       itemCount: movies.length,
    //       itemBuilder: (_, int index) => _movieItem(movies[index]),
    //     );
    //   },
    // );
    return StreamBuilder(
      // Cuando el stream emita un valor se dispara.
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _movieItem(movies[index]),
        );
      },
    );
  }
}

class _movieItem extends StatelessWidget {
  final Movie movie;

  const _movieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 70,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Row(
          children: [
            Icon(Icons.star_border, color: Colors.black45),
            Text(movie.voteAverage.toString()),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                movie.originalTitle,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        onTap: () {
          // print(movie.title);
          Navigator.pushNamed(context, 'details', arguments: movie);
        });
  }
}
