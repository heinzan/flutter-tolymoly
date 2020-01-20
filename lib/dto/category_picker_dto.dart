import 'package:tolymoly/models/category_model.dart';

class CategoryPickerDto {
  int id;
  int categoryIdLevel1;
  int categoryIdLevel2;
  int categoryIdLevel3;
  String name;
  String mmUnicode;
  bool isNewAd;
  CategoryPickerDto();

  CategoryPickerDto.fromCategoryModel(CategoryModel model) {
    this.id = model.id;
    this.name = model.name;
    this.categoryIdLevel1 = model.categoryIdLevel1;
    this.categoryIdLevel2 = model.categoryIdLevel2;
    this.categoryIdLevel2 = model.categoryIdLevel2;
    this.mmUnicode = model.mmUnicode;
  }
}
