import 'dart:math';

import 'package:trailer_lender/src/models/image.dart';
import 'package:trailer_lender/src/service/image/baseImageService.dart';

import '../database_helper.dart';

class LocalImageService implements BaseImageService {


  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<ItemImage> createImage(String path, String name) async {
    ItemImage img = ItemImage("", name, localUrl: path, fireBaseId: "", id: Random().nextInt(10000));
    await _db.insert(img.toMap(), DatabaseHelper.tableImage);
    return img;
  }
}