import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/chat_api.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/chat_detail_dto.dart';
import 'package:tolymoly/models/chat_group_model.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/pages/chat/chat_detail.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/chat_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class ChatList extends StatefulWidget {
  final bool isAll;
  final bool isBuying;
  final bool isSelling;

  ChatList.all()
      : this.isAll = true,
        this.isBuying = true,
        this.isSelling = true;

  ChatList.buying()
      : this.isAll = false,
        this.isBuying = true,
        this.isSelling = false;

  ChatList.selling()
      : this.isAll = false,
        this.isBuying = false,
        this.isSelling = true;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Logger logger = new Logger();
  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;

  int pageNumber = 1;

  List<ChatGroupModel> chats = new List<ChatGroupModel>();
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();

    this._getData(pageNumber);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData(pageNumber);
      }
    });

    if (ChatUtil.hasFcmToken) {
      // ChatUtil.setNotification(_onNotification);
      streamSubscription =
          ChatUtil.notificationStreamController.stream.listen((message) {
        print(
            "chat list > notificationStreamController: " + message.toString());

        // int notificationMessageId = int.parse(message['data']['messageId']);
        // int senderId = int.parse(message['data']['senderId']);
        int ownerId = int.parse(message['data']['ownerId']);
        print(AuthUtil.userId);
        print(ownerId);
        print(widget.isBuying);

        if (widget.isBuying && ownerId != AuthUtil.userId ||
            !widget.isBuying && ownerId == AuthUtil.userId) {
          chats.clear();
          _getData(1);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (streamSubscription != null) streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Pagination"),
      // ),
      body: isLoading ? _buildProgressIndicator() : _buildList(),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _getData(int pageNumber) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var response;
    if (widget.isAll) {
      response = await ChatApi.get(pageNumber);
    } else if (widget.isBuying) {
      response = await ChatApi.getBuying(pageNumber);
    } else if (widget.isSelling) {
      response = await ChatApi.getSelling(pageNumber);
    }

    print('_getData...');
    print(response.toString());
    List<ChatGroupModel> newChats = new List<ChatGroupModel>();
    // nextPage = response.data['next'];

    for (int i = 0; i < response.data.length; i++) {
      newChats.add(ChatGroupModel.fromMap(response.data[i]));
    }

    isLoading = false;
    chats.addAll(newChats);
    setState(() {});
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: chats.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == chats.length) {
          return _buildProgressIndicator();
        } else {
          int userId;
          String username;
          String userImage;

          if (widget.isAll) {
            if (chats[index].buyerId == AuthUtil.userId) {
              userId = chats[index].sellerId;
              username = chats[index].sellerName;
              userImage = chats[index].sellerImage;
            } else {
              userId = chats[index].buyerId;
              username = chats[index].buyerName;
              userImage = chats[index].buyerImage;
            }
          } else if (widget.isBuying) {
            userId = chats[index].sellerId;
            username = chats[index].sellerName;
            userImage = chats[index].sellerImage;
          } else if (widget.isSelling) {
            userId = chats[index].buyerId;
            username = chats[index].buyerName;
            userImage = chats[index].buyerImage;
          }

          // userId =
          //     widget.isBuying ? chats[index].sellerId : chats[index].buyerId;
          // username = widget.isBuying
          //     ? chats[index].sellerName
          //     : chats[index].buyerName;
          // userImage = widget.isBuying
          //     ? chats[index].sellerImage
          //     : chats[index].buyerImage;

          Widget subTitleWidget;
          if (chats[index].message.startsWith('http') &&
              chats[index].message.endsWith('.jpg')) {
            subTitleWidget = Row(children: <Widget>[
              Text(LocaleUtil.get(LabelConstant.photo)),
              SizedBox(width: 10),
              Icon(
                Icons.photo_camera,
                color: Colors.grey[700],
              )
            ]);
          } else {
            subTitleWidget = Text(chats[index].message, maxLines: 2);
          }
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: chats[index].adImage,
            ),
            // trailing: new Image.network(
            //   chats[index][widget.isBuying ? 'sellerImage' : 'buyerImage']
            //       .toString(),
            // ),
            trailing: _buildTrailing(context, chats[index].unreadCount,
                chats[index].updatedDate, username, userImage),
            // title: Text(chats[index].adTitle),
            title: Text(username),
            subtitle: subTitleWidget,
            onTap: () {
              ChatDetailDto dto = new ChatDetailDto();
              dto.adId = chats[index].adId;
              dto.adTitle = chats[index].adTitle;
              dto.adImage = chats[index].adImage;
              dto.adPrice = chats[index].adPrice;
              dto.adPriceType = chats[index].adPriceType;
              dto.receiverId = userId;
              dto.receiverName = username;
              dto.receiverImage = userImage;

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => widget.isBuying
              //             ? ChatDetail.buying(dto)
              //             : ChatDetail.selling(dto)));

              // Navigator.of(context, rootNavigator: true).pushReplacement(
              //     MaterialPageRoute(
              //         builder: (context) => ChatDetail.buying(dto)));

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  if (widget.isAll) {
                    if (chats[index].buyerId == AuthUtil.userId)
                      return ChatDetail.buying(dto);
                    return ChatDetail.selling(dto);
                  } else if (widget.isBuying) {
                    return ChatDetail.buying(dto);
                  } else if (widget.isSelling) {
                    return ChatDetail.selling(dto);
                  }
                }),
              ).then((val) {
                chats.clear();
                _getData(1);
              });
            },
          );
        }
      },
      controller: _scrollController,
    );
  }

  Widget _buildTrailing(BuildContext context, int unreadCount,
      String updatedDate, String username, String userImage) {
    Widget unread;
    double maxRadius = 20;
    if (unreadCount == 0) {
      unread = CircleAvatar(
        maxRadius: maxRadius,
        // backgroundImage: NetworkImage(userImage),
        backgroundImage: CachedNetworkImageProvider(userImage),
      );
    } else {
      unread = CircleAvatar(
        maxRadius: 15,
        child: FittedBox(
          child: Text(
            unreadCount.toString(),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          fit: BoxFit.fill,
        ),
        backgroundColor: Colors.red,
      );
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          child: Text(
            timeago.format(DateTime.parse(updatedDate)),
            style: TextStyle(fontSize: 10.0),
          ),
          padding: EdgeInsets.only(bottom: 1.0),
        ),
        unread
      ],
    );
  }
}
