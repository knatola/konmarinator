class Note {
  Note({this.text, this.itemId, this.date, this.id});

  int id;
  int itemId;
  final String text;
  DateTime date;

  Map<String, dynamic> toMap() => {
    '_id': id,
    'itemId': itemId,
    'noteText': text,
    'date': date.toIso8601String(),
  };

  static Note fromMap(Map map) {
    int id = map['_id'];
    int itemId = map['itemId'];
    DateTime date = DateTime.tryParse(map['date']);
    String text = map['noteText'];

    return Note(text: text, itemId: itemId, date: date, id: id);
  }
}