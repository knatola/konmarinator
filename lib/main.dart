import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:trailer_lender/src/bloc/itemBloc.dart';

import 'package:trailer_lender/src/ui/Home.dart';
import 'package:trailer_lender/src/ui/konMariList/konMariView.dart';

void main() {
  Logger.level = Level.verbose;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ItemBlocProvider(
              child: MaterialApp(
                title: 'Konmatinator',
                theme: ThemeData(
                  // This is the theme of your application.
                    primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
                    primaryColorLight: Colors.grey[500],
                    primaryColorDark: Colors.grey[900],
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                    ),
                    primaryTextTheme: TextTheme(
                      headline: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                      title: TextStyle(fontSize: 24.0),
                      body1: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    errorColor: Colors.red[300],
                    accentColor: Color.fromRGBO(36, 38, 57, 1.0),
                  bottomAppBarTheme: BottomAppBarTheme(color: Colors.transparent),
                  canvasColor: Colors.blueGrey[300],
                ),
                home: KonMariView(),
        ));
  }
}
