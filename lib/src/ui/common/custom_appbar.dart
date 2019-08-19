import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(5),
              child: Row(children: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.verified_user),
                  onPressed: () => null,
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}