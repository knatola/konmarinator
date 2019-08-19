import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({this.onPressed, this.selected});

  final void Function(int) onPressed;
  final int selected;

  void useCallBack(int index) {
    onPressed(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      child: BottomAppBar(
        color:
            Theme.of(context).primaryColor, //Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home,
                  color: selected == 0 ? Colors.cyan : Colors.white),
              onPressed: () {
                useCallBack(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.category,
                  color: selected == 1 ? Colors.cyan : Colors.white),
              onPressed: () {
                useCallBack(1);
              },
            ),
            IconButton(
              icon: Icon(Icons.account_box,
                  color: selected == 2 ? Colors.cyan : Colors.white),
              onPressed: () {
                useCallBack(2);
              },
            )
          ],
        ),
      ),
    );
  }
}
