import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;

  Slide({
    @required this.imageUrl,
    @required this.title,

  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/usuario.png',
    title: 'FOTOGRAFIA',
  ),
  Slide(
    imageUrl: 'assets/images/huella.png',
    title: 'HUELLA DIGITAL',
  ),
  Slide(
    imageUrl: 'assets/images/voz.png',
    title: 'FIRMA VOCAL',
  ),
  Slide(
    imageUrl: 'assets/images/psos-signo.png',
    title: 'DESPOSITAR PESOS',
  ),
];
