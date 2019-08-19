class ItemUtility {

  ItemUtility({this.id, this.itemId, this.utility, this.date});

  int id;
  int itemId;
  int utility; // in 0-4
  DateTime date;

  Map<String, dynamic> toMap() => {
    '_id': id,
    'itemId': itemId,
    'utility': utility,
    'date': date.toIso8601String(),
  };

  static ItemUtility fromMap(Map map) {
    int id = map['_id'];
    int itemId = map['itemId'];
    int utility= map['utility'];
    DateTime date = DateTime.tryParse(map['date']);

    return ItemUtility(
      id: id,
      itemId: itemId,
      utility: utility,
      date: date,
    );
  }
//
//  static ItemUtility fromSnapshot(DocumentSnapshot snapshot) {
//    int id = snapshot['_id'];
//    int itemId = snapshot['itemId'];
//    int utility = snapshot['utility'];
//    DateTime date = DateTime.tryParse(snapshot['date']);
//
//    return ItemUtility(
//      id: id,
//      itemId: itemId,
//      utility: utility,
//      date: date,
//    );
//  }

  static String utilToString(int utility) {
    switch (utility) {
      case 1:
        return 'No usage';
      case 2:
        return 'Low';
      case 3:
        return 'Medium';
      case 4:
        return 'Useful';
      case 5:
        return 'Very useful';
      default:
        throw Exception('Invalid int argument for utility: $utility');
    }
  }

  @override
  String toString() {
    return 'ItemUtility{id: $id itemId: $itemId, utility: $utility, date: $date}';
  }
}
