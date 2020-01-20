class SellerProfileDto {
  int id;
  String username;
  String image;
  String description;
  bool isRegisteredByFacebook;
  bool isRegisteredBySms;
  String joinedDate;

  SellerProfileDto.fromMap(Map<String, dynamic> map) {
    print(map.toString());
    this.id = map['id'];
    this.username = map['username'];
    this.image = map['image'];
    this.description = map['description'] == null ? '' : map['description'];
    this.isRegisteredByFacebook = map['isRegisteredByFacebook'];
    this.isRegisteredBySms = map['isRegisteredBySms'];
    this.joinedDate = map['joinedDate'];
  }
}
