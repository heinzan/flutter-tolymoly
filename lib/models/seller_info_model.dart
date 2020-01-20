class SellerInfo {
  int id;
  String name;
  String image;
  bool isRegisteredByFacebook;
  bool isRegisteredBySms;
  String phone;
  String facebookMessenger;

  SellerInfo.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.image = map['image'];
    this.isRegisteredByFacebook = map['isRegisteredByFacebook'];
    this.isRegisteredBySms = map['isRegisteredBySms'];
    this.phone = map['phone'];
    this.facebookMessenger = map['facebookMessenger'];
  }
}
