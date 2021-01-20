import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/providers/movies_provider.dart';
import 'package:peliculas_flutter/src/widgets/card_swiper_widget.dart';

//como lo dice el nombre esta sería nuestra pagina de inicio nuestro home
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Safearea es un widget el cual se encarga de colocar las cosas en el lugar donde se pueden desplegar
      appBar: AppBar(
        title: Text('Peliculas'),
        backgroundColor: Colors.indigoAccent,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Container(
        child: Column(
          children: [_swiperCards()],
        ),
      ),
    );
  }

  Widget _swiperCards() {
    final moviesProvider = new MoviesProvider();
    moviesProvider.getInCinemas();
    return CardSwiper(movies: [1, 2, 3, 4, 5]);
  }
}
