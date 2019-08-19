import 'package:flutter/material.dart';
import 'package:trailer_lender/src/models/item.dart';

class ListCard extends StatelessWidget {

  ListCard(this.callback, this.item);

  final void Function(Item) callback;
  void showImage() { callback(item); }

  final Item item;

  @override
  Widget build(BuildContext context) {

    final cardActions = ButtonTheme.bar( // make buttons use the appropriate styles for cards
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: const Text('INFO'),
            onPressed: () {
              callback(item);

            },
          ),
        ],
      ),
    );

    Widget _buildImage() {
      if (item.images.isNotEmpty) {
        final url = item.images[0].imageUrl;
        if (url != null && url != "") {
          print('url: $url');
          return Image.network(url, fit: BoxFit.contain);
        }
      }

      return Text('Failed to load image');
    }

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: showImage,
              child: _buildImage(),
            ),

            Divider(),
            CustomListTile(item),
            cardActions
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {

  CustomListTile(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        item.name,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Text(
              item.category,
              style: TextStyle(color: Colors.black)
          )
        ],
      ),
    );
  }
}