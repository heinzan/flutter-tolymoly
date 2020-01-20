class MobileBrandDto {
  int id;
  String name;

  MobileBrandDto(id, name);

  MobileBrandDto.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
