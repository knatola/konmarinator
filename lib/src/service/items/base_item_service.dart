
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/item_category.dart';

abstract class BaseItemSource {

  Future<Item> getItem(int id);

  Stream<Item> getItems();

  Future<List<Item>> getUsersItems(String userId);

  Stream<List<Item>> getItemsByCategory(String category);

  Future<void> addItem(Item item);

  Future<void> update(Item item);

  Future<void> delete(Item item);

  Future<void> createCategory(ItemCategory category);

  Future<List<ItemCategory>> getCategories();

  Future<void> deleteCategory(ItemCategory category);

}