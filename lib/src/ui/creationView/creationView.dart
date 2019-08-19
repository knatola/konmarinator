import 'package:flutter/material.dart';

class CreationView extends StatefulWidget {
  @override
  CreationState createState() => CreationState();
}

class CreationState extends State<CreationView> {
  Widget _createBody() {
    return Container(
      color: Colors.black,
      child: Center(
          child: Container(
        color: Colors.red,
        height: 400,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createBody(),
    );
  }
}
