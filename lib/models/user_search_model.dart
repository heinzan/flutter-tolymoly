class UserSearchModel {
  String text;
  int type;

  UserSearchModel.fromDb(Map<String, dynamic> map) {
    this.text = map['text'];
    this.type = map['type'];
  }
}
