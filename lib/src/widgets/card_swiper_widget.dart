import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;


    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.65,
        itemHeight: _screenSize.height * 0.55,
        itemBuilder: (BuildContext context, int index){
          
          peliculas[index].uniqueId = '${peliculas[index].id}_swiper';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/images/no-image.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl(),
      ),
    );
  }
}
