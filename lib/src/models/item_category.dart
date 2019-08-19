class ItemCategory {

  ItemCategory({this.id, this.name, this.firebaseId});

  String name;
  int id;
  String firebaseId;

  Map<String, dynamic> toMap() => {
    'name': name,
    '_id': id,
    'firebaseId': firebaseId,
  };

  static ItemCategory fromMap(Map<String, dynamic> map) {
    String name = map['name'];
    int id = map['_id'];
    String firebaseId = map['firebaseId'] != null? map['firebaseId'] : "";

    return ItemCategory(id: id, name: name, firebaseId: firebaseId);
  }
}