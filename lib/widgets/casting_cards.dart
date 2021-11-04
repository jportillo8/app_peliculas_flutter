import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_flutter/models/models.dart';
import 'package:peliculas_flutter/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  // Añandiendo los actores
  final int movieId;

  const CastingCards(this.movieId);

  @override
  Widget build(BuildContext context) {
    // Añadiendo el casting de las movies
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        // Aca ya tendremos la data
        final cast = snapshot.data!;
        // xxxxxxxxxxxxxxxxxxxxxxx
        return Container(
          margin: EdgeInsets.only(bottom: 30.0),
          width: double.infinity,
          height: 180,
          // color: Colors.red,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _Castcard(cast[index]);
            },
          ),
        );
      },
    );
  }
}

class _Castcard extends StatelessWidget {
  final Cast actor;

  const _Castcard(this.actor);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: 110,
      height: 100,
      // color: Colors.green,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                height: 140.0,
                width: 100,
                fit: BoxFit.cover,
                image: NetworkImage(actor.fullProfilePath)),
          ),
          Text(
            actor.originalName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
