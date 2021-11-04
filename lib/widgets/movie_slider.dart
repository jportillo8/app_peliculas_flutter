import 'package:flutter/material.dart';
import 'package:peliculas_flutter/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> moviesPopulares;
  final String? title;

  // Infinite Scroll
  final Function onNextPage;

  const MovieSlider(
      {Key? key,
      required this.moviesPopulares,
      this.title,
      required this.onNextPage})
      : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  // Lineas de codigo para poder hacer el infity Scroll
  final ScrollController scrollcontroller = new ScrollController();
  @override
  void initState() {
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.pixels >=
          scrollcontroller.position.maxScrollExtent - 500) {
        widget.onNextPage();

        // print('Obtener siguiente pagina');

      }

      // print(scrollcontroller.position.pixels);
      // print(scrollcontroller.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

  @override
  Widget build(BuildContext context) {
    // print(moviesPopulares[8].title);
    return Container(
      width: double.infinity,
      height: 260.0,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.widget.title!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(height: 5.0),
          Expanded(
            child: ListView.builder(
                controller: scrollcontroller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.moviesPopulares.length,
                itemBuilder: (_, int index) => _MoviePoster(
                    widget.moviesPopulares[index],
                    '${widget.title}-${index}-${widget.moviesPopulares[index].id}')),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster(this.movie, this.heroId);

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                // Hora de enviar la movie a la pagina de detalles
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    width: 130,
                    height: 180,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.fullPosterImg)),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
