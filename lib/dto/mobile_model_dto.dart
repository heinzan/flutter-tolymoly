class MobileModelDto {
  int id;
  String name;

  MobileModelDto(id, name);

  MobileModelDto.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
