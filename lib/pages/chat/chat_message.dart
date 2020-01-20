import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tolymoly/dto/chat_message_dto.dart';
import 'package:tolymoly/models/ad_detail_model.dart';
import 'package:tolymoly/models/ad_image.dart';
import 'package:tolymoly/models/chat_model.dart';
import 'package:tolymoly/pages/buy/buy_image.dart';
import 'package:tolymoly/pages/chat/chat_image_preview.dart';

class ChatMessage extends StatelessWidget {
  // ChatMessage({this.message, this.time, this.delivered, this.isMe});
  // ChatMessage({this.data, this.receiverId});
  // final data, receiverId;
  // final String time;
  // final data, delivered, isMe;

  final ChatMessageDto chatMessageDto;
  ChatMessage(this.chatMessageDto);

  @override
  Widget build(BuildContext context) {
    final String message = chatMessageDto.message;
    Widget messageWidget;

    if (message.startsWith('http') && message.endsWith('.jpg')) {
      messageWidget = InkWell(
          onTap: () {
            List<AdImageModel> models = new List();
            models.add(AdImageModel(imageNo: 0, imageUrl: message));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyImage(
                    adImageModels: models,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    initialIndex: 1,
                  ),
                ));
          },
          child: Container(
              height: 300,
              child: CachedNetworkImage(
                imageUrl: message,
                // placeholder: (context, url) => Container(
                //     height: 100,
                //     width: 100,
                //     child: CircularProgressIndicator())
                //     )
              )));
    } else {
      messageWidget = SelectableText(message);
    }
    // final String message =
    //     '(id:${chatMessageDto.id}) ${chatMessageDto.message}';

    final String time = timeago.format(chatMessageDto.createdDate);
    final bool delivered = chatMessageDto.isRead;
    // final bool isMe = data['senderId'] == receiverId ? false : true;
    final bool isMe =
        chatMessageDto.senderId == chatMessageDto.receiverId ? false : true;

    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final tickColor = delivered ? Colors.blue : Colors.black38;

    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment: align,
              children: <Widget>[
                messageWidget,
                // Text(message),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(time,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 10.0,
                            )),
                        SizedBox(width: 3.0),
                        if (isMe)
                          Icon(
                            icon,
                            size: 12.0,
                            color: tickColor,
                          )
                      ],
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}
