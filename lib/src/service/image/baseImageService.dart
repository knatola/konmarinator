
import 'dart:io';

import 'package:trailer_lender/src/models/image.dart';

abstract class BaseImageService {

  Future<ItemImage> createImage(String path, String name);

}