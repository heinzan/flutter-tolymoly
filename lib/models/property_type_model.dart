class PropertyTypeModel {
  int id;
  String name;
  String zawgyi;

  PropertyTypeModel(this.id, this.name);

  PropertyTypeModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.zawgyi = map['zawgyi'];
  }
}
