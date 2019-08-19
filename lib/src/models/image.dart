
class ItemImage {
  ItemImage(this.imageUrl, this.imageName,
      {this.itemId, this.id, this.fireBaseId, this.localUrl});

  final int id;
  final String fireBaseId;
  final String imageUrl;
  final String localUrl;
  final String imageName;
  int itemId;

  Map<String, dynamic> toMap() =>
      {
        'name': imageName,
        '_id': id,
        'imageUrl': imageUrl,
        'itemId': itemId,
        'fireBaseId': fireBaseId,
        'localUrl': localUrl,
//    'userId': userId,
      };

  static ItemImage fromMap(Map map) {
    var id = map['_id'];
    var name = map['name'];
    var imageUrl = map['imageUrl'];
    var localUrl = map['localUrl'];
    int itemId = map['itemId'];
    var fireBaseId = (map['fireBaseId'] != null) ? map['fireBaseId'] : "";

    return ItemImage(
      imageUrl,
      name,
      id: id,
      itemId: itemId,
      fireBaseId: fireBaseId,
      localUrl: localUrl
    );
  }

//  static ItemImage fromSnapshot(DocumentSnapshot map) {
//    var id = map['_id'];
//    var name = map['name'];
//    var imageUrl = map['imageUrl'];
//    var localUrl = map['localUrl'];
//    var itemId = map['iteimId'];
//    var fireBaseId = (map['fireBaseId'] != null) ? map['fireBaseId'] : "";
//
//    return ItemImage(
//      name,
//      imageUrl,
//      id: id,
//      itemId: itemId,
//      fireBaseId: fireBaseId,
//      localUrl: localUrl,
//    );
//  }

  @override
  String toString() {
    return 'ItemImage{id: $id, fireBaseId: $fireBaseId, localUrl: $localUrl imageUrl: $imageUrl, imageName: $imageName, itemId: $itemId}';
  }
}