class CategoryDto {
  int id;
  int parentId;
  int categoryIdLevel1;
  int categoryIdLevel2;
  int categoryIdLevel3;
  String name;
  String zawgyi;
  bool hasChild;

  CategoryDto();

  CategoryDto.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.parentId = map['parentId'];
    this.name = map['name'];
  }
}
