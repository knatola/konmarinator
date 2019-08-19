import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer_lender/src/bloc/base_bloc.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/item_category.dart';
import 'package:trailer_lender/src/models/item_utility.dart';
import 'package:trailer_lender/src/models/note.dart';
import 'package:trailer_lender/src/service/database_helper.dart';
import 'package:trailer_lender/src/service/items/local_item_source.dart';
import 'package:trailer_lender/src/service/logger.dart';

class ItemBloc implements BaseBloc {
  ItemBloc();

  final log = getLogger('ItemBloc');
  final LocalItemSource local = LocalItemSource(DatabaseHelper.instance); // todo loosely couple this, (BaseItemSource)
  List<Item> _items = [];
  List<ItemCategory> _categories = [];
  Item _currentItem;

  final _listController = StreamController<List<Item>>.broadcast();
  final _categoryController = StreamController<List<ItemCategory>>.broadcast();
  final _singleItemController = StreamController<Item>.broadcast();

  Stream<List<Item>> get listStream => _listController.stream;
  Sink<List<Item>> get listStreamIn => _listController.sink;

  Stream<Item> get singleStream => _singleItemController.stream;
  Sink<Item> get singleStreamIn => _singleItemController.sink;

  Stream<List<ItemCategory>> get categoryStream => _categoryController.stream;
  Sink<List<ItemCategory>> get categoryStreamIn => _categoryController.sink;

  Future<Item> createItem(Item item, {bool useRemote}) async {
    log.d('Trying to create item: $item');
    if (item.userId == null || item.userId == "") {
      throw Exception("User id is null!");
    } else {
      return local.addItem(item).whenComplete(() {
        _items.add(item);
        listStreamIn.add(_items);
      });
    }
  }

  Future<Item> getItem(int id, bool useRemote) async {
    final item = await local.getItem(id);
    _currentItem = item;
    singleStreamIn.add(_currentItem);
    return item;
  }

  Future<void> updateItem(Item item) {
    _currentItem = item;
    log.d('updating item: $item');
    return local.update(item).whenComplete(() => singleStreamIn.add(_currentItem));
  }

  Future<void> createNote(Note note) {
    return local.createNote(note).whenComplete(() {
      _currentItem?.notes.add(note);
      singleStreamIn.add(_currentItem);
    });
  }

  Future<void> createUtil(ItemUtility util) {
    return local.createUtil(util);
  }

  Future<List<Item>> getUsersItems(String userId) async {
    final items = await local.getUsersItems(userId);
    _items.clear();
    _items.addAll(items);
    _items.forEach(
        (item) => log.d('Index: ${_items.indexOf(item).toString()}, -> $item'));
    listStreamIn.add(_items);
    return _items;
  }

  int getDaysUtility(Item item, DateTime date) {
    log.d('Getting utility for $date, from item: ${item.name}');
    try {
      return item.utilities
          .firstWhere((item) => (item.date.difference(date).inDays == 0 &&
              item.date.weekday == date.weekday),
      orElse: () {
            final util = ItemUtility(
                itemId: item.id, utility: 1, id: Random().nextInt(1000), date: date);
            createUtil(util);
            return util;
      })
          .utility;
    } catch (e) {
      log.d('No utility for that date, creating -->');
      createUtil(ItemUtility(
          itemId: item.id, utility: 1, id: Random().nextInt(1000), date: date));
      return 1;
    }
  }

  Future<void> deleteItem(Item item) {
    return local.delete(item).whenComplete(() {
      _items.remove(item);
      listStreamIn.add(_items);
    });
  }

  Future<void> createCategory(ItemCategory category) {
    log.d('Creating category: $category');
    return local.createCategory(category).whenComplete(() => _categories.add(category));
  }

  Future<void> deleteCategory(ItemCategory category) {
      // todo: implement
  }

  Future<List<ItemCategory>> getCategories() async {
    final categories = await local.getCategories();
    _categories.clear();
    _categories.add(ItemCategory(name: 'all', id: 1111111)); // insert "All" category here, pretty hacky, but it is what it is
    _categories.addAll(categories);
    categoryStreamIn.add(_categories);
    log.d('Categories size: ${_categories.length}');
    return categories;
  }

  @override
  void dispose() {
    _listController.close();
    _singleItemController.close();
    _categoryController.close();
  }
}

class ItemBlocProvider extends InheritedWidget {
  final bloc = ItemBloc();

  ItemBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static ItemBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ItemBlocProvider)
            as ItemBlocProvider)
        .bloc;
  }
}
