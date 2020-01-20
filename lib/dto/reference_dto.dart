class ReferenceDto {
  int id;
  String name;

  ReferenceDto.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
