class Reference {
  int id;
  String name;

  Reference(this.id, this.name);

  Reference.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
