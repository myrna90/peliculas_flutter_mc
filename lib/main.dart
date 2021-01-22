import 'package:flutter/material.dart';
import 'package:peliculas_flutter/src/pages/details_movie.dart';
import 'package:peliculas_flutter/src/pages/home_page.dart';

//esta linea viene siendo nuestra llamada la cual se va renderizar nuestro index en react
void main() => runApp(MyApp());

//El main es nuestra pagina principal la cual contiene la llamada de las rutas sería nuestro App.js en react
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peliculas',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/details': (BuildContext context) => DetailsMovie(),
        });
  }
}
