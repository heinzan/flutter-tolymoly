class HorizontalAdDto {
  int id;
  String image;
  double price;
  int priceType;

  HorizontalAdDto.fromMap(Map<String, dynamic> map) {
    String image = map['image'];
    image = image.replaceAll('160x160', '100x100');

    this.id = map['id'];
    this.image = map['image'];
    this.price = map['price'];
    this.priceType = map['priceType'];
  }
}
