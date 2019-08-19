import 'package:sqflite/sqflite.dart';
import 'package:trailer_lender/src/models/image.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/item_category.dart';
import 'package:trailer_lender/src/models/item_utility.dart';
import 'package:trailer_lender/src/models/note.dart';
import 'package:trailer_lender/src/service/database_helper.dart';
import 'package:trailer_lender/src/service/items/base_item_service.dart';
import 'package:trailer_lender/src/service/logger.dart';

class LocalItemSource extends BaseItemSource {
  var log = getLogger('LocalItemSource');

  LocalItemSource(this._db);

  final DatabaseHelper _db;

  @override
  Future<Item> getItem(int id) async {
    Database db = await _db.database;
    List<Map> results = await db.rawQuery('''
      SELECT * FROM ${DatabaseHelper.tableItem} WHERE ${DatabaseHelper.columnId} = ?
      ''', [id]);

    if (results.length > 0) {
      Item item = Item.fromMap(results.first);
      item.utilities = await _getUtilities(item);
      item.images = await _getImages(item);

      return Item.fromMap(results.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<Item>> getUsersItems(String userId) async {
    List<Map<String, dynamic>> result =
        await _db.queryAllRows(DatabaseHelper.tableItem);
    List<Item> items = result.map((i) => Item.fromMap(i)).toList();

    await Future.forEach(items, (item) async {
      item.notes = await _getNotes(item);
      item.utilities = await _getUtilities(item);
      item.images = await _getImages(item);
    });

    return items;
  }

  @override
  Future<void> update(Item item) {
    return _db.update(item.toDbModel(), DatabaseHelper.tableItem).then((id) {
      item.images.forEach(
          (image) => _db.update(image.toMap(), DatabaseHelper.tableImage));
      item.utilities.forEach(
          (util) => _db.update(util.toMap(), DatabaseHelper.tableUtility));
      item.notes.forEach(
              (note) => _db.update(note.toMap(), DatabaseHelper.tableNote));
    });
  }

  @override
  Future<Item> addItem(Item item) async {
    log.d('Creating/Adding item: $item');
    if (await _db.exists(item.id, DatabaseHelper.tableItem,
        fbId: item.firebaseId)) {
      log.d('Found existing item with this id: $item.id');
      return _db.update(item.toDbModel(), DatabaseHelper.tableItem).then((id) {
        item.images.forEach((image) {
          image.itemId = item.id;
          _db.update(image.toMap(), DatabaseHelper.tableImage);
        });

        item.utilities.forEach((util) {
          util.itemId = item.id;
          _db.update(util.toMap(), DatabaseHelper.tableUtility);
        });

        item.notes.forEach((note) {
          note.itemId = item.id;
          _db.update(note.toMap(), DatabaseHelper.tableUtility);
        });

        return item;
      });
    } else {
      return _db.insert(item.toDbModel(), DatabaseHelper.tableItem).then((id) {
        item.images.forEach((image) {
          image.itemId = item.id;
          log.d('Creating image: $image');
          _db.insert(image.toMap(), DatabaseHelper.tableImage);
        });
        item.utilities.forEach((util) {
          util.itemId = item.id;
          log.d('Creating util: $util');
          _db.insert(util.toMap(), DatabaseHelper.tableUtility);
        });
        item.notes.forEach((note) {
          note.itemId = item.id;
          _db.update(note.toMap(), DatabaseHelper.tableUtility);
        });
        return item;
      });
    }
  }

  @override
  Future<void> delete(Item item) {
    // todo this cascading delete should be done in the db
    return _db.delete(item.id, DatabaseHelper.tableItem).whenComplete(() {
      item.notes.forEach((i) => _deleteNote(i));
      item.images.forEach((i) => _deleteImage(i));
      item.utilities.forEach((i) => _deleteUtil(i));
    });
  }

  Future<void> createUtil(ItemUtility util) {
    return _db.insert(util.toMap(), DatabaseHelper.tableUtility);
  }

  @override
  Future<void> createCategory(ItemCategory category) {
    return _db.insert(category.toMap(), DatabaseHelper.tableCategory);
  }


  @override
  Future<List<ItemCategory>> getCategories() async {
    var db = await _db.database;
    List<Map> results = await db.rawQuery('''
      SELECT * FROM ${DatabaseHelper.tableCategory}
    ''');

    if (results.isNotEmpty) {
      return results.map((i) => ItemCategory.fromMap(i)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<Function> deleteCategory(ItemCategory category) {

  }

  Future<void> createNote(Note note) {
    return _db.insert(note.toMap(), DatabaseHelper.tableNote);
  }

  @override
  Stream<List<Item>> getItemsByCategory(String category) {
    return null;
  }

  @override
  Stream<Item> getItems() {
    return null;
  }

  Future<void> _deleteUtil(ItemUtility util) {
    return _db.delete(util.id, DatabaseHelper.tableUtility);
  }

  Future<void> _deleteNote(Note note) {
    return _db.delete(note.id, DatabaseHelper.tableNote);
  }

  Future<void> _deleteImage(ItemImage img) {
    return _db.delete(img.id, DatabaseHelper.tableImage);
  }

  Future<List<ItemUtility>> _getUtilities(Item item) async {
    var db = await _db.database;
    List<Map> results = await db.rawQuery('''
      SELECT * FROM ${DatabaseHelper.tableUtility} WHERE itemId = ?
    ''', [item.id]);

    if (results.isNotEmpty) {
      return results.map((i) => ItemUtility.fromMap(i)).toList();
    } else {
      return [];
    }
  }

  Future<List<ItemImage>> _getImages(Item item) async {
    var db = await _db.database;
    List<Map> results = await db.rawQuery('''
      SELECT * FROM ${DatabaseHelper.tableImage} WHERE itemId = ?
    ''', [item.id]);

    if (results.isNotEmpty) {
      List<ItemImage> imgs = results.map((i) => ItemImage.fromMap(i)).toList();
      return imgs;
    } else {
      return [];
    }
  }

  Future<List<Note>> _getNotes(Item item) async {
    var db = await _db.database;
    List<Map> results = await db.rawQuery('''
      SELECT * FROM ${DatabaseHelper.tableNote} WHERE itemId = ?
    ''', [item.id]);

    if (results.isNotEmpty) {
      List<Note> notes = results.map((i) => Note.fromMap(i)).toList();
      return notes;
    } else {
      return [];
    }
  }
}
