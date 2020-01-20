import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUploadUtil {
  static Future<List<int>> compressFile(File file) async {
    int sizeBefore = file.lengthSync();
    var result = await FlutterImageCompress.compressWithFile(file.absolute.path,
        quality: 20);
    int sizeAfter = result.length;
    print('image compressed before: $sizeBefore , after: $sizeAfter');
    return result;
  }
}
