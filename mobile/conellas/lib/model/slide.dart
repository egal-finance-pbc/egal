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
    imageUrl: 'assets/images/user.png',
    title: 'FOTOGRAFIA',
  ),
  Slide(
    imageUrl: 'assets/images/fingerprint.png',
    title: 'HUELLA DIGITAL',
  ),
  Slide(
    imageUrl: 'assets/images/voice.png',
    title: 'FIRMA VOCAL',
  ),
  Slide(
    imageUrl: 'assets/images/dollar-sign.png',
    title: 'DEPOSITAR PESOS',
  ),
];
