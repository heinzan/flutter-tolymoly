class CategoryModel {
  int id;
  int parentId;
  int categoryIdLevel1;
  int categoryIdLevel2;
  int categoryIdLevel3;
  String name;
  String mmUnicode;
  bool hasChild;

  CategoryModel();
  // Category(this.id, this.parentId, this.categoryIdLevel1, this.categoryIdLevel2,
  //     this.categoryIdLevel3, this.name, this.hasChild);

  CategoryModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.parentId = map['parent_id'];
    this.categoryIdLevel1 = map['category_id_level1'];
    this.categoryIdLevel2 = map['category_id_level2'];
    this.categoryIdLevel3 = map['category_id_level3'];
    this.name = map['name'];
    this.mmUnicode = map['mm_unicode'];
    this.hasChild = map['has_child'] == 1 ? true : false;
  }
}
