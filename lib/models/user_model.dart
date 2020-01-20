// import 'dart:convert';

// UserModel welcomeFromJson(String str) => UserModel.fromJson(json.decode(str));

// String welcomeToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String username;
  String image;
  String description;
  // String facebookName;
  // String facebookAccountKitPhone;
  bool isRegisteredByFacebook;
  bool isRegisteredBySms;
  String facebookMessenger;
  String joinedDate;
  // DateTime createdDate;
  String phone;
  String token;

  UserModel({
    this.id,
    this.username,
    this.image,
    this.description,
    this.isRegisteredByFacebook,
    this.isRegisteredBySms,
    // this.facebookName,
    // this.facebookAccountKitPhone,
    this.facebookMessenger,
    this.phone,
    // this.createdDate,
    this.joinedDate,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
        id: json["id"],
        username: json["username"],
        image: json["image"],
        description: json["description"],
        isRegisteredByFacebook: json["isRegisteredByFacebook"],
        isRegisteredBySms: json["isRegisteredBySms"],
        // facebookName: json["facebookName"],
        // facebookAccountKitPhone: json["facebookAccountKitPhone"],
        facebookMessenger: json["facebookMessenger"],
        phone: json["phone"],
        // createdDate: DateTime.parse(json["createdDate"]),
        joinedDate: json["joinedDate"],
        token: json["token"],
      );

  UserModel.fromDb(Map<String, dynamic> map) {
    this.id = map['id'];
    this.username = map['username'];
    this.image = map['image'];
    this.description = map['description'];
    // this.facebookName = map['facebook_name'];
    // this.facebookAccountKitPhone = map['facebook_account_kit_phone'];
    this.isRegisteredByFacebook =
        map['is_registered_by_facebook'] == 1 ? true : false;
    this.isRegisteredBySms = map['is_registered_by_sms'] == 1 ? true : false;
    this.facebookMessenger = map['facebook_messenger'];
    this.phone = map['phone'];
    // this.createdDate = map['created_date'] == null
    //     ? null
    //     : DateTime.parse(map['created_date']);
    this.joinedDate = map['joined_date'];
    this.token = map['token'];
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "username": username,
  //       "image": image,
  //       "description": description,
  //       "facebookName": facebookName,
  //       "facebookAccountKitPhone": facebookAccountKitPhone,
  //       "facebookMessenger": facebookMessenger,
  //       "createdDate": createdDate.toIso8601String(),
  //       "token": token,
  //     };
}
