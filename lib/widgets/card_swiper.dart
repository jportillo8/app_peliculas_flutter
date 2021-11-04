import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:peliculas_flutter/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print(movies[8].title);

    // Arreglo de error de carga
    if (this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      // color: Colors.red,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.9,
        itemBuilder: (BuildContext context, int index) {
          // Movi en la posicion index
          final movie = movies[index];
          // print(index);
          // print(movie.id);
          // id unico.
          movie.heroId = 'swiper-${movie.id}';
          return GestureDetector(
            // Hora de enviar la movie a la pagina de detalles
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            // Hero para dar animacion a la imagen
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.fullPosterImg)),
              ),
            ),
          );
        },
      ),
    );
  }
}
