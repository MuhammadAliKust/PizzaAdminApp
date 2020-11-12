import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

Widget displayRating(var rating) {
  print("From Display Rating");
  print(rating);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmoothStarRating(
          allowHalfRating: true,
          isReadOnly: true,
          starCount: 5,
          rating: rating,
          size: 15.0,
          color: Colors.yellow,
          borderColor: Colors.yellow,
          spacing: 0.0),
      rating == 0 
          ? Text(' (N/A)', style: TextStyle(color: Color(0xff979797), fontSize: 10))
          : Text('( ${double.parse((rating).toStringAsFixed(1))} )', style: TextStyle(color: Color(0xff979797))),
    ],
  );
}
