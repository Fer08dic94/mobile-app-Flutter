import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/dark.jpg",
    ],
    title: "The Dark Side Of The Moon",
    price: 340.99,
    description:
        "Es un álbum conceptual, el octavo de estudio del grupo musical británica de rock progresivo Pink Floyd. Fue lanzado el 1 de marzo de 1973 en los Estados Unidos y el 24 de marzo del mismo año en el Reino Unido.",
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/coldp.jpg",
    ],
    title: "A Head Full of Dreams",
    price: 200.50,
    description:
        "Es el séptimo álbum de estudio de la banda británica de pop rock Coldplay. Fue lanzando comercialmente el 4 de diciembre de 2015.",
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/abby.jpg",
    ],
    title: "Abby Road",
    price: 360.55,
    description:
        "Abbey Road es el undécimo álbum de estudio publicado por la banda británica de rock The Beatles, sería lanzado el 26 de septiembre de 1969 en Reino Unido por Apple Records.",
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/wish.jpg",
    ],
    title: "Wish You Were Here",
    price: 290.50,
    description:
        "Es el noveno álbum de estudio de la banda británica de rock Pink Floyd, lanzado en septiembre de 1975 e inspirado en el material que compusieron durante su gira europea de 1974 y que grabaron en los Abbey Road Studios de Londres",
    isFavourite: true,
    isPopular: true,
  ),
];

const String description = "";
