class ChatGroupModel {
  int adId;
  String adTitle;
  String adImage;
  double adPrice;
  int adPriceType;
  String message;
  int sellerId;
  String sellerName;
  String sellerImage;
  int buyerId;
  String buyerName;
  String buyerImage;
  int unreadCount;
  String updatedDate;

  // int receiverId;
  // String receiverName;
  // String receiverImage;

  ChatGroupModel();

  ChatGroupModel.fromMap(Map<String, dynamic> map) {
    this.adId = map['adId'];
    this.adTitle = map['adTitle'];
    this.adImage = map['adImage'];
    this.adPrice = map['adPrice'];
    this.adPriceType = map['adPriceType'];
    this.message = map['message'];
    this.sellerId = map['sellerId'];
    this.sellerName = map['sellerName'];
    this.sellerImage = map['sellerImage'];
    this.buyerId = map['buyerId'];
    this.buyerName = map['buyerName'];
    this.buyerImage = map['buyerImage'];
    this.unreadCount = map['unreadCount'];
    this.updatedDate = map['updatedDate'];

    // this.isBuying = map['isBuying'] == 1 ? true : false;
    // this.receiverId = map['receiverId'];
    // this.receiverName = map['receiverName'];
    // this.receiverImage = map['receiverImage'];
  }
}
