
import 'package:flutter/material.dart';

class ExplainedText extends StatelessWidget {

  ExplainedText(this.secondaryText, this.mainText);

  final String secondaryText; // explaining text

  final String mainText; // the main displayed text

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Text(secondaryText,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white
        ),
        ),
        Padding(
          padding: const EdgeInsets.only( top: 8.0),
          child: Text(
            mainText,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black
            ),
          ),
        )
      ],
    );
  }
}