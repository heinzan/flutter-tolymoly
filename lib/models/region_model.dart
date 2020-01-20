class RegionModel {
  int id;
  String name;

  RegionModel(this.id, this.name);

  RegionModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
