import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, secondaryText;
  final Function callBack;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.secondaryText,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(top: 16),
      decoration: new BoxDecoration(
//        color: Colors.white,
        gradient: getGradient(context),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              FlatButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text(buttonText),
              ),
                secondaryText != null ? FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.callBack();// To close the dialog
                  },
                  child: Text(secondaryText),
                ): Container(),
            ]
            ),
          ),
        ],
      ),
    );
  }
}