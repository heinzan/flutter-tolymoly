class BuyFilterModel {
  int regionId;
  String regionName;
  int townshipId;
  String townshipName;
  int categoryId;
  String categoryName;
  int sortId;
  int conditionId;
  String priceFrom;
  String priceTo;
  int priceType;

  BuyFilterModel();

  BuyFilterModel.fromMap(Map<String, dynamic> map) {
    this.regionId = map['region_id'];
    this.regionName = map['region_name'];
    this.townshipId = map['township_id'];
    this.townshipName = map['township_name'];
    this.categoryId = map['category_id'];
    this.categoryName = map['category_name'];
    this.sortId = map['sort_id'];
    this.conditionId = map['condition_id'];
    this.priceFrom = map['price_from'];
    this.priceTo = map['price_to'];
    this.priceType = map['price_type'];
  }
}
