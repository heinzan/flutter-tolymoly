class TownshipModel {
  int id;
  int regionId;
  String name;

  TownshipModel(this.id, this.name, this.regionId);

  TownshipModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.regionId = map['region_id'];
    this.name = map['name'];
  }
}
