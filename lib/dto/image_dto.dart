import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageDto {
  Image image;
  String filePath;
  String url;
  int imageNo;
  Asset asset;

  ImageDto(this.image, this.filePath, this.url, this.imageNo, this.asset);
}
