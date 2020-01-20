import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tolymoly/api/my_favourite_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/chat_detail_dto.dart';
import 'package:tolymoly/models/ad_detail_model.dart';
import 'package:tolymoly/pages/auth/auth_tab.dart';
import 'package:tolymoly/pages/chat/chat_detail.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyAdDetailBottom extends StatefulWidget {
  final ChatDetailDto chatDetailDto;
  final bool isFavourite;
  final int adId;
  final String phone;
  final String facebookMessenger;
  BuyAdDetailBottom(this.chatDetailDto, this.isFavourite, this.adId, this.phone,
      this.facebookMessenger);

  _BuyAdDetailBottomState createState() => _BuyAdDetailBottomState();
}

class _BuyAdDetailBottomState extends State<BuyAdDetailBottom> {
  bool isFavourite = false;
  bool isLoading = false;

  @override
  void initState() {
    isFavourite = widget.isFavourite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: _buildSave(),
          ),
          _buildChat(),
          _buildCall()
        ],
      ),
    );
  }

  Widget _buildChat() {
    String label;
    int flex;
    Color color;
    widget.phone == null ? flex = 2 : flex = 1;

    var onTap;
    if (widget.facebookMessenger == null) {
      label = 'Chat';
      onTap = _onTapChat;
      color = ColorConstant.primary;
    } else {
      label = 'FB';
      onTap = _onTapFacebookMessenger;
      color = ColorConstant.facebook;
    }

    return Flexible(
      flex: flex,
      child: _buildContact(label, onTap, color, Icons.chat_bubble_outline),
    );
  }

  Widget _buildCall() {
    if (widget.phone == null) return SizedBox.shrink();

    return Flexible(
      flex: 1,
      child: _buildContact('Call', _onTapCall, ColorConstant.phone, Icons.call),
    );
  }

  void _onTapSave() async {
    if (isLoading) return;
    isLoading = true;
    Response response = await MyFavouriteApi.addRemove(widget.adId);
    if (response.statusCode != 200) return;

    isFavourite = !isFavourite;

    isLoading = false;

    setState(() {});
  }

  void _onTapChat() {
    // ChatDetailDto chatDetailDto = new ChatDetailDto();
    // chatDetailDto.adId = widget.chatDetailDto.id;
    // chatDetailDto.adTitle = widget.chatDetailDto.title;
    // chatDetailDto.adImage = widget.chatDetailDto.coverImage;
    // chatDetailDto.receiverId = widget.chatDetailDto.sellerInfo.id;
    // chatDetailDto.receiverName = widget.chatDetailDto.sellerInfo.name;
    // chatDetailDto.receiverImage = widget.chatDetailDto.sellerInfo.image;
    // chatDetailDto.adPrice = widget.chatDetailDto.price;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatDetail.buying(widget.chatDetailDto)),
      // MaterialPageRoute(builder: (context) => BuyAdListListview()),
    );
  }

  Future _onTapFacebookMessenger() async {
    if (await canLaunch(widget.facebookMessenger)) {
      await launch(widget.facebookMessenger);
    } else {
      ToastUtil.error('Could not launch ${widget.facebookMessenger}');
    }
  }

  void _onTapCall() {
    List<String> phones;
    phones = widget.phone.split(',');
    if (phones.length > 1) {
      _showPhoneList(phones);
    } else {
      launch('tel:${widget.phone}');
    }
  }

  void _showPhoneList(List<String> phones) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(LocaleUtil.get(LabelConstant.phone)),
            content: Container(
              width: double.maxFinite,
              // height: 300.0,
              child: Scrollbar(
                  child: ListView.builder(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: phones.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(phones[index]),
                    onTap: () {
                      launch('tel:${phones[index]}');
                    },
                  );
                },
              )),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _buildSave() {
    return Padding(
        padding: EdgeInsets.only(right: 5),
        child: OutlineButton(
          onPressed: () async {
            bool isAtuh = AuthUtil.validate(context);
            if (!isAtuh) return;

            _onTapSave();
          },
          color: ColorConstant.favourite,
          shape: StadiumBorder(),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: isFavourite ? Colors.red : Colors.black54,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  "Save",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildContact(String label, var onTap, Color color, IconData icon) {
    return FlatButton(
      onPressed: () async {
        bool isAtuh = AuthUtil.validate(context);
        if (!isAtuh) return;

        onTap();
      },
      color: color,
      shape: StadiumBorder(),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildfacebook() {
  //   return FlatButton(
  //     onPressed: () async {
  //       bool isAtuh = AuthUtil.validate(context);
  //       if (!isAtuh) return;

  //       _onTapChat();
  //     },
  //     color: Colors.blue[600],
  //     child: Center(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Icon(
  //             Icons.chat_bubble_outline,
  //             color: Colors.white,
  //           ),
  //           SizedBox(
  //             width: 4.0,
  //           ),
  //           Text(
  //             "Facebook",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
