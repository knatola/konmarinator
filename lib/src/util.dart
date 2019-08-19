
import 'dart:math';

import 'package:flutter/material.dart';

LinearGradient getGradient(BuildContext context, [int dir = 3]) {
//  int dir = Random().nextInt(2);
  var bottomOffset = FractionalOffset.bottomRight;
  var topOffset = FractionalOffset.topLeft;
  if (dir == 1) {
      bottomOffset = FractionalOffset.bottomLeft;
      topOffset = FractionalOffset.topRight;
  } else if (dir == 0) {
    bottomOffset = FractionalOffset.topRight;
    topOffset = FractionalOffset.bottomLeft;
  }
  return  LinearGradient(
    colors: [Color.fromRGBO(36, 38, 57, 1.0), Color.fromRGBO(58, 66, 86, 1.0)],
    begin: topOffset,
    end: bottomOffset,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
}

String dateToReadable(DateTime date) {
  final day = date.day;
  final month = date.month;
  final year = date.year;

  return '$day.$month.$year';
}