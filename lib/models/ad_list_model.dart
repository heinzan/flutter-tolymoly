class AdListModel {
  int id;
  String coverImage;
  int categoryId;
  int regionId;
  int townshipId;
  String title;
  String description;
  double price;
  int priceType;
  int conditionId;

  int womanTopSizeId;
  int womanBottomSizeId;
  int womanShoeSizeId;

  int propertyTypeId;
  int propertySubTypeId;
  int totalFloor;

  int masterBedroom;
  int bedroom;
  int bathroom;

  int floorWidth;
  int floorLength;
  int floorSize;
  int landWidth;
  int landLength;
  int landSize;

  int adStatus;
  String userImage;
  String username;

  // AdListModel();

  AdListModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.coverImage = map['coverImage'];
    this.categoryId = map['categoryId'];
    this.regionId = map['regionId'];
    this.townshipId = map['townshipId'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.priceType = map['priceType'];
    this.conditionId = map['conditionId'];

    this.conditionId = map['womanTopSizeId'];
    this.conditionId = map['womanBottomSizeId'];
    this.conditionId = map['womanShoeSizeId'];

    this.conditionId = map['propertyTypeId'];
    this.conditionId = map['propertySubTypeId'];
    this.conditionId = map['totalFloor'];

    this.conditionId = map['masterBedroom'];
    this.conditionId = map['bedroom'];
    this.conditionId = map['bathroom'];

    this.conditionId = map['floorWidth'];
    this.conditionId = map['floorLength'];
    this.conditionId = map['floorSize'];
    this.conditionId = map['landWidth'];
    this.conditionId = map['landLength'];
    this.conditionId = map['landSize'];

    this.adStatus = map['adStatus'];
    this.userImage = map['userImage'];
    this.username = map['userName'];
  }
}
