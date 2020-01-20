class UserPreferenceModel {
  int keyboardType;
  int displayLanguageType;
  int regionId;
  String regionName;
  int townshipId;
  String townshipName;
  int sellTownshipId;
  String sellTownshipName;
  int sellRegionId;
  String sellRegionName;

  UserPreferenceModel.fromMap(Map<String, dynamic> map) {
    this.keyboardType = map['keyboard_type'];
    this.displayLanguageType = map['display_language_type'];

    this.regionId = map['region_id'];
    this.regionName = map['region_name'];
    this.townshipId = map['township_id'];
    this.townshipName = map['township_name'];

    this.sellRegionId = map['sell_region_id'];
    this.sellRegionName = map['sell_region_name'];
    this.sellTownshipId = map['sell_township_id'];
    this.sellTownshipName = map['sell_township_name'];
  }
}
