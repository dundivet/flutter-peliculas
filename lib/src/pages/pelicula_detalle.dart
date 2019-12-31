import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar( pelicula ),
        ],
      )
    );
  }


  Widget _crearAppBar( Pelicula pelicula ) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text( 
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0) ,
        ),
        background: FadeInImage(
          image: NetworkImage( pelicula.getBackdropImg() ),
          placeholder: AssetImage('assets/images/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      )
    );
  }
}