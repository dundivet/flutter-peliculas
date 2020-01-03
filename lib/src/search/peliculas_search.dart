import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculasSearch extends SearchDelegate {

  final PeliculasProvider provider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: provider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final peliculas = snapshot.data;
        
        return ListView(
          children: peliculas.map( (p) {
            p.uniqueId = '${p.id}-search';

            return ListTile(
              title: Text( p.title ),
              leading: Hero(
                tag: p.uniqueId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                    image: NetworkImage(p.getPosterImg()),
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                  ),
                ),
              ),
              onTap: () {
                close(context, null);

                Navigator.pushNamed(context, 'detalle', arguments: p);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
