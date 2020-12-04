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
    title: 'PHOTOGRAPHY',
  ),
  Slide(
    imageUrl: 'assets/images/fingerprint.png',
    title: 'FINGERPRINT',
  ),
  Slide(
    imageUrl: 'assets/images/voice.png',
    title: 'VOCAL SIGNATURE',
  ),
  Slide(
    imageUrl: 'assets/images/dollar-sign.png',
    title: 'DEPOSIT PESOS',
  ),
];
