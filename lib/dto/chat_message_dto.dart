class ChatMessageDto {
  int id;
  int senderId;
  String message;
  DateTime createdDate;
  bool isRead;
  int receiverId;

  ChatMessageDto();

  ChatMessageDto.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.senderId = map['senderId'];
    this.message = map['message'];
    this.createdDate = DateTime.parse(map['createdDate']);
    this.isRead =
        map['isRead'] == null || map['isRead'] == false ? false : true;
    this.receiverId = map['receiverId'];
  }
}
