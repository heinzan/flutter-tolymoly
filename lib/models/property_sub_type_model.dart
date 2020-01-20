class PropertySubTypeModel {
  int id;
  String name;
  String zawgyi;
  int propertyTypeId;

  PropertySubTypeModel(this.id, this.name, this.propertyTypeId);

  PropertySubTypeModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.zawgyi = map['zawgyi'];
  }
}
