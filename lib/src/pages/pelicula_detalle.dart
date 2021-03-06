import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/cast_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar( pelicula ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              SizedBox( height: 10.0,),
              _posterTitulo( context, pelicula ),
              _descripcion( pelicula ),
              _descripcion( pelicula ),
              _descripcion( pelicula ),
              _descripcion( pelicula ),
              _castDetalles( pelicula ),
            ]),
          ),
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

  Widget _posterTitulo( BuildContext context, Pelicula pelicula ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text( pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text( pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis, ),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead, ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget _descripcion( Pelicula pelicula ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text( 
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );

  }

  Widget _castDetalles (Pelicula pelicula) {
    
    final CastProvider castProvider = new CastProvider();

    return FutureBuilder(
      future: castProvider.getCast( pelicula.id ),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if (snapshot.hasData) {
          return _crearActoresPageView( snapshot.data );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

  Widget _crearActoresPageView( List<Actor> actores ) {

    return SizedBox(
      height: 150.0,
      child: PageView.builder(
        pageSnapping: false,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(actores[index].getProfileImg()),
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                  ),
                ),
                Text( actores[index].name )
              ],
            )
          );
        },
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.25
        ),
        itemCount: actores.length,
      ),
    );
  }
}
