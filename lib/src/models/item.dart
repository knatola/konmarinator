import 'package:trailer_lender/src/models/image.dart';
import 'package:trailer_lender/src/models/item_utility.dart';
import 'package:trailer_lender/src/models/note.dart';
import 'package:trailer_lender/src/service/database_helper.dart';

class Item {
  Item({
    this.name,
    this.id,
    this.category,
    this.userId,
    this.startTime,
    this.endTime,
    this.utilities,
    this.images,
    this.firebaseId,
    this.notes,
  });

  static const tableName = 'item';
  final String name;
  int id;
  String firebaseId;
  String userId;
  String category;
  DateTime startTime;
  DateTime endTime;

  List<ItemUtility> utilities = [];
  List<ItemImage> images = [];
  List<Note> notes = [];

  int getDaysUtility(DateTime date) {
    if (this.utilities.isEmpty)
      return 2;
    else if (this.utilities.isNotEmpty) {
      return this
          .utilities
          .firstWhere((item) => item.date.difference(date).inDays == 0,
              orElse: () => utilities.first)
          .utility;
    } else {
      return 2;
    }
  }

  addUtility(ItemUtility utility) {
    utilities.add(utility);
  }

  setUrls(List<ItemImage> images) {
    images.addAll(images);
  }

  addUrl(ItemImage image) {
    images.add(image);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
        'category': category,
        'userId': userId,
        'startTime': startTime != null
            ? startTime.toIso8601String()
            : DateTime.now().toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'utilities': utilities.map((util) => util.toMap()).toList(),
        'images': images.map((image) => image.toMap()).toList(),
        'notes': notes.map((note) => note.toMap()).toList(),
        DatabaseHelper.columnFireBaseId: firebaseId,
      };

  Map<String, dynamic> toDbModel() => {
        'name': name,
        '_id': id,
        'category': category,
        'userId': userId,
        'startTIme': startTime != null
            ? startTime.toIso8601String()
            : DateTime.now().toIso8601String(),
        'endTime': endTime.toIso8601String(),
        DatabaseHelper.columnFireBaseId: firebaseId,
      };

  double getAverageUtil() {
    int total =
        this.utilities.fold(0, (value, element) => element.utility + value);
    return total / this.utilities.length;
  }

  static Item fromMap(Map map) {
    String name = map['name'];
    int id = map['_id'];
    String category = map['category'];
    String ownerId = map['userId'] != null ? map['userId'] : "";
    String startTime = map['startTime'] != null ? map['startTime'] : "";
    String endTime = map['endTime'] != null ? map['endTime'] : "";
    List<ItemUtility> utilities =
        map['utilities'] != null ? map['utilities'] : [];
    List<ItemImage> images = map['images'] != null ? map['images'] : [];
    List<Note> notes = map['notes'] != null ? map['notes'] : [];
    String firebaseId = map['firebaseId'] != null ? map['firebaseId'] : "";

    var start = DateTime.tryParse(startTime);
    var end = DateTime.tryParse(endTime);

    return Item(
      name: name,
      id: id,
      category: category,
      userId: ownerId,
      startTime: start,
      endTime: end,
      utilities: utilities,
      images: images,
      firebaseId: firebaseId,
      notes: notes,
    );
  }

  static String getRecommendationText(double avg) {
    if (avg <= 1) {
      return 'This item seems to be pretty useless.';
    } else if (avg >= 1 && avg < 2.5) {
      return 'You do not use this item much.';
    } else if (avg >= 2.5 && avg < 3.5) {
      return 'You have decent use for this item.';
    } else if (avg >= 3.5 && avg <= 5) {
      return 'This item is a must have!';
    } else {
      return '';
    }
  }

  @override
  String toString() {
    return 'Item{name: $name, id: $id, firebaseId: $firebaseId, userId: $userId,'
        ' category: $category, startTime: $startTime, endTime: $endTime,'
        ' utilities: $utilities, images: $images'
        ' notes: $notes}';
  }
}
