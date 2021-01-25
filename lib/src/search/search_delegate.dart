import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/models/movie_model.dart';
import 'package:peliculas_flutter/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';

  final moviesProvider = new MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query:
          '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // El builder que crea los resultados que se van a mostrar
    return Center(
        child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.blueAccent,
      child: Text(selection),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: moviesProvider.movieSearch(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 150.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(movie.originalTitle),
                  subtitle: Text(movie.title),
                  onTap: () {
                    close(context, null);
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, '/details', arguments: movie);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

/*

final listaSugerida = (query.isEmpty)
        ? moviesNew
        : movies
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            selection = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }
 */
