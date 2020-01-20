import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tolymoly/api/chat_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/chat_detail_dto.dart';
import 'package:tolymoly/dto/chat_message_dto.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/pages/chat/chat_detail_appbar.dart';
import 'package:tolymoly/pages/chat/chat_message.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/chat_util.dart';
import 'package:tolymoly/utils/image_upload_utl.dart';
import 'package:tolymoly/utils/price_util.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ChatDetail extends StatefulWidget {
  final ChatDetailDto chatDetailDto;
  final bool isBuying;
  // ChatDetail(this.data);
  ChatDetail.buying(this.chatDetailDto) : this.isBuying = true;
  ChatDetail.selling(this.chatDetailDto) : this.isBuying = false;

  @override
  State createState() => new ChatDetailState();
}

class ChatDetailState extends State<ChatDetail> {
  // Logger logger = new Logger();
  // final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  // bool isLoading = false;
  RestartableTimer timer;
  ScrollController _scrollController = new ScrollController();
  // int pageNumber = 1;
  int refreshIntervalSeconds = 5;
  int currentLargestMsgId = 0;
  int currentLastSmallestMsgId = 0;
  StreamSubscription streamSubscription;
  bool showCamera = true;
  bool showSend = false;

  @override
  void dispose() {
    _stopPeriodicData();
    _scrollController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // _pushNotification();

    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getPaginationData();
      }
    });

    if (ChatUtil.hasFcmToken) {
      // ChatUtil.setNotification(_onNotification);
      streamSubscription =
          ChatUtil.notificationStreamController.stream.listen((message) {
        print('======================');
        print("chat detail > notificationStreamController: " +
            message.toString());
        print('======================');

        int notificationMessageId = int.parse(message['data']['messageId']);
        int senderId = int.parse(message['data']['senderId']);
        if (senderId != widget.chatDetailDto.receiverId) return;

        if (notificationMessageId <= currentLargestMsgId) return;

        _getDataByNotification();
      });

      _getDataByNotification();
    } else {
      _getNewData();
    }
  }

  // void _onNotification(Map<String, dynamic> message) async {
  //   int notificationMessageId = int.parse(message['data']['messageId']);
  //   int senderId = int.parse(message['data']['senderId']);
  //   print(notificationMessageId.toString());
  //   print(senderId.toString());
  //   if (senderId != widget.chatDetailDto.receiverId) return;

  //   if (notificationMessageId <= currentLargestMsgId) return;

  //   _getDataByNotification();
  // }

  void _getDataByNotification() async {
    List data = await _getDataById(0);

    if (data.length == 0) return;

    if (_getLargestId(data) <= currentLargestMsgId) return;

    _seLargestId(data);

    _setSmallestId(data);

    _clearData();

    _setData(data);

    setState(() {});
  }

  void _startPeriodicData() {
    if (ChatUtil.hasFcmToken) return;

    print('_getPeriodicData');
    _stopPeriodicData();
    timer = new RestartableTimer(
        Duration(seconds: refreshIntervalSeconds), _getNewData);
  }

  void _stopPeriodicData() {
    print('_stopPeriodicData');
    if (timer != null) timer.cancel();
  }

  void _getNewData() async {
    print('_getNewData');

    List data = await _getDataById(0);

    if (data.length == 0) {
      _startPeriodicData();
      return;
    }

    if (_getLargestId(data) <= currentLargestMsgId) {
      _startPeriodicData();
      return;
    }

    _seLargestId(data);

    _setSmallestId(data);

    _clearData();

    _setData(data);

    _startPeriodicData();

    setState(() {});
  }

  void _getPaginationData() async {
    print('_getPaginationData');

    _stopPeriodicData();

    List data = await _getDataById(currentLastSmallestMsgId);

    if (data.length == 0) {
      ToastUtil.info(LabelConstant.noMoreData);
      _startPeriodicData();
      return;
    }

    _setSmallestId(data);

    _setData(data);

    _startPeriodicData();

    setState(() {});
  }

  Future<List> _getDataById(int msgId) async {
    var response;
    if (widget.isBuying) {
      response = await ChatApi.getOneByBuying(
          widget.chatDetailDto.adId, widget.chatDetailDto.receiverId, msgId);
    } else {
      response = await ChatApi.getOneBySelling(
          widget.chatDetailDto.adId, widget.chatDetailDto.receiverId, msgId);
    }

    return response.data;
  }

  int _getLargestId(List data) {
    return data[0]['id'];
  }

  void _seLargestId(List data) {
    currentLargestMsgId = data[0]['id'];
  }

  void _setSmallestId(List data) {
    currentLastSmallestMsgId = data[data.length - 1]['id'];
  }

  void _clearData() {
    _messages.clear();
  }

  void _setData(List data) {
    List<ChatMessage> newMessages = new List();
    // nextPage = response.data['next'];
    for (int i = 0; i < data.length; i++) {
      // history.add(new ChatMessage(text: response.data[i]['message']));
      //ChatMessage({this.message, this.time, this.delivered, this.isMe});
      ChatMessageDto dto = ChatMessageDto.fromMap(data[i]);
      // dto.isRead = false;
      dto.receiverId = widget.chatDetailDto.receiverId;
      newMessages.add(ChatMessage(dto));
    }

    _messages.addAll(newMessages);
  }

  void _onSend(String text) async {
    text = text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    showCamera = true;
    showSend = false;

    _stopPeriodicData();

    Response response = await ChatApi.post({
      "adId": widget.chatDetailDto.adId,
      "receiverId": widget.chatDetailDto.receiverId,
      "message": BurmeseUtil.toUnicode(text)
      // 'token': _fcmToken
    });

    if (response.statusCode != 200) return;

    _getNewData();
  }

  @override
  Widget build(BuildContext context) {
    String price = PriceUtil.price(
        widget.chatDetailDto.adPrice, widget.chatDetailDto.adPriceType);

    return WillPopScope(
        onWillPop: () async {
          // not working, not sure why
          print('onWillPop...');
          _stopPeriodicData();

          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade50,
          appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            // title: new Text(widget.data['adTitle'])),
            title: ChatDetailAppbar(widget.chatDetailDto),
            backgroundColor: ColorConstant.primary,
          ),
          body: new Column(children: <Widget>[
            new ListTile(
              leading: new Image.network(
                widget.chatDetailDto.adImage,
              ),

              // trailing: new CircleAvatar(
              //   backgroundImage:
              //       NetworkImage(widget.data['receiverImage'].toString()),
              // ),
              // trailing: _buildTrailing(context, chats[index]['unreadCount'],
              //     chats[index]['createdDate']),
              title: Text(widget.chatDetailDto.adTitle),
              subtitle: Text(price),
              onTap: () {
                // print(chats[index]);
                // var data = {
                //   'adId': chats[index]['adId'],
                //   'receiverId': chats[index]
                //       [widget.isBuying ? 'sellerId' : 'buyerId'],
                //   'isBuying': widget.isBuying ? true : false
                // };
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BuyAdDetail(widget.chatDetailDto.adId)));
              },
            ),
            Divider(color: Colors.black),
            Flexible(
                child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
              controller: _scrollController,
            )),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ]),
        ));
  }

  Widget _buildTextComposer() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: <Widget>[
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 6,
              controller: _textController,
              onSubmitted: _onSend,
              onChanged: (text) {
                if (text.trim().length > 0) {
                  showCamera = false;
                  showSend = true;
                } else {
                  showCamera = true;
                  showSend = false;
                }

                setState(() {});
              },
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          if (showCamera)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.camera_enhance),
                  onPressed: () => _onPickImage()),
            ),
          if (showSend)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              // child: IconButton(
              //     icon: Icon(Icons.send),
              //     onPressed: () => _onSend(_textController.text)),
              child: FlatButton(
                  // label: Text(''),
                  child: Text('Send',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  shape: StadiumBorder(),
                  // icon: Icon(Icons.send),
                  color: Colors.orange,
                  onPressed: () => _onSend(_textController.text)),
            ),
        ]));
  }

  void _onPickImage() async {
    String filePath = await _pickImage();
    if (filePath == null) return;

    ProgressIndicatorUtil.showProgressIndicator(context);
    String downloadUrl = await uploadImage(
        widget.chatDetailDto.adId, widget.chatDetailDto.receiverId, filePath);

    ProgressIndicatorUtil.closeProgressIndicator();

    if (downloadUrl.isEmpty) return;

    _onSend(downloadUrl);
  }

  Future<String> _pickImage() async {
    int maxImage = 1;

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: maxImage, enableCamera: true);
    } on Exception catch (e) {
      print('MultiImagePicker > error...');
      print(e);
      // error = e.message;
    }

    if (resultList.length == 0) return null;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return null;

    return await resultList[0].filePath;
  }

  Future<String> uploadImage(int adId, int receiverId, String imagePath) async {
    print('upload image...');

    var resUrl = await ChatApi.getUploadUrl(adId, receiverId);

    List<int> compressedFile =
        await ImageUploadUtil.compressFile(File(imagePath));

    var resUploadToS3 = await http.put(resUrl.data['uploadUrl'],
        body: compressedFile); // cannot use dio here, not sure why

    if (resUploadToS3.statusCode == 200) {
      print('image > s3 : success');
      return resUrl.data['downloadUrl'];
    } else {
      print('image > s3 : error');
      print(resUploadToS3.body);
      ToastUtil.error(LabelConstant.imageUploadError);
    }

    return '';
  }
}
