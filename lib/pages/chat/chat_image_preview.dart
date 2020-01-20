import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/image_dto.dart';
import 'package:tolymoly/utils/dialog_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class ChatImagePreview extends StatefulWidget {
  final String image;
  ChatImagePreview({this.image});

  _ChatImagePreviewState createState() => _ChatImagePreviewState();
}

class _ChatImagePreviewState extends State<ChatImagePreview> {
  static const int indexDelete = 0;
  static const int indexReplace = 1;
  static const int indexEdit = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Preview')),
        backgroundColor: ColorConstant.primary,
      ),
      // body: Image.file(widget.data['file']),
      // body: widget.image,
      body: Container(
          alignment: Alignment.center,
          child: CachedNetworkImage(imageUrl: widget.image)),
      // body: FittedBox(
      //   child: widget.image,
      //   fit: BoxFit.fill,
      // ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: 0, // this will be set when a new tab is tapped
        selectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.delete),
            title: new Text(LocaleUtil.get('Delete')),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.find_replace),
            title: new Text(LocaleUtil.get('Replace')),
          ),
        ],
        onTap: (index) async {
          switch (index) {
            case indexDelete:
              bool isDelete = await DialogUtil.confirmation(
                  context, LocaleUtil.get('Delete'));
              if (isDelete) Navigator.pop(context, {'isDelete': true});
              break;
            case indexReplace:
              Navigator.pop(context, {'isReplace': true});
              break;
            case indexEdit:
              Navigator.pop(context, {'isEdit': true});
              break;
          }
        },
      ),
    );
  }
}
