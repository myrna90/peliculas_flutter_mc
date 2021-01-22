import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  //
  final List<Movie> movies;

  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, i) {
          return _createCard(context, movies[i]);
        },
      ),
    );
  }

  Widget _createCard(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-poster';
    final movieCard = Container(
        margin: EdgeInsets.only(
          right: 15.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: movie.uniqueId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: (AssetImage('assets/img/loading.gif')),
                    image: NetworkImage(movie.getPosterImg()),
                    fit: BoxFit.cover,
                    height: 160.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                movie.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ));

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: movie);
      },
      child: movieCard,
    );
  }

  //Referencia
  // List _cards(BuildContext context) {
  //   return movies.map((movie) {}).toList();
  // }
}
