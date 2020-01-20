import 'package:flutter/material.dart';
import 'package:tolymoly/dto/chat_detail_dto.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';

class ChatDetailAppbar extends StatelessWidget {
  final ChatDetailDto chatDetailDto;
  ChatDetailAppbar(this.chatDetailDto);

  @override
  Widget build(BuildContext context) {
    double nameWidth = MediaQuery.of(context).size.width - 140;

    return InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new BuyAdList.fromSellerProfile(
                      chatDetailDto.receiverId)));
        },
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(chatDetailDto.receiverImage),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
                constraints: BoxConstraints(maxWidth: nameWidth),
                child: Text(
                  // ads[index].username + ' 1231 313123123',
                  chatDetailDto.receiverName,
                  overflow: TextOverflow.ellipsis,
                  // maxLines: 1,
                )),
          ],
        ));
  }
}
