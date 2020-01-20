import 'package:tolymoly/dto/attribute_dto.dart';
import 'package:tolymoly/dto/attribute_dto2.dart';
import 'package:tolymoly/dto/category_dto.dart';
import 'package:tolymoly/models/ad_image.dart';
import 'package:tolymoly/models/seller_info_model.dart';

class AdDetailModel {
  int id;
  String coverImage;
  int categoryId;
  List<CategoryDto> category;
  int regionId;
  String region;
  int townshipId;
  String township;
  String title;
  String description;
  double price;
  // int priceTypeId;
  int priceType;
  int conditionId;
  String condition;

  int womanTopSizeId;
  int womanBottomSizeId;
  int womanShoeSizeId;

  int propertyTypeId;
  String propertyType;
  int propertySubTypeId;
  String propertySubType;
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
  String createdDate;
  List<AdImageModel> image;
  SellerInfo sellerInfo;
  bool owner;
  bool isFavourite;
  // List<AttributeDto2> attributes;

  AdDetailModel.fromMap(Map<String, dynamic> map) {
    var list = map['image'] as List;
    List<AdImageModel> imagesList =
        list.map((i) => AdImageModel.fromJson(i)).toList();

    list = map['category'] as List;
    List<CategoryDto> categoryList =
        list.map((i) => CategoryDto.fromMap(i)).toList();

    // list = map['attributes'] as List;
    // List<AttributeDto2> attributes =
    //     list.map((i) => AttributeDto2.fromMap(i)).toList();

    this.id = map['id'];
    this.coverImage = map['coverImage'];
    this.categoryId = map['categoryId'];
    this.category = categoryList;
    this.regionId = map['regionId'];
    this.townshipId = map['townshipId'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.priceType = map['priceType'];
    this.conditionId = map['conditionId'];

    this.womanTopSizeId = map['womanTopSizeId'];
    this.womanBottomSizeId = map['womanBottomSizeId'];
    this.womanShoeSizeId = map['womanShoeSizeId'];

    this.propertyTypeId = map['propertyTypeId'];
    this.propertySubTypeId = map['propertySubTypeId'];
    this.totalFloor = map['totalFloor'];

    this.masterBedroom = map['masterBedroom'];
    this.bedroom = map['bedroom'];
    this.bathroom = map['bathroom'];

    this.floorWidth = map['floorWidth'];
    this.floorLength = map['floorLength'];
    this.floorSize = map['floorSize'];
    this.landWidth = map['landWidth'];
    this.landLength = map['landLength'];
    this.landSize = map['landSize'];

    this.adStatus = map['adStatus'];
    this.createdDate = map['createdDate'];
    this.image = imagesList;

    this.sellerInfo = SellerInfo.fromMap(map['sellerInfo']);
    this.owner = map['owner'];
    this.isFavourite = map['isFavourite'];

    // this.attributes = attributes;
  }
}
