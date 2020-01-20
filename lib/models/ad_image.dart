class AdImageModel {
  final int imageNo;
  final String imageUrl;

  AdImageModel({this.imageNo, this.imageUrl});

  factory AdImageModel.fromJson(Map<String, dynamic> parsedJson) {
    return AdImageModel(
        imageNo: parsedJson['imageNo'], imageUrl: parsedJson['imageUrl']);
  }
}
