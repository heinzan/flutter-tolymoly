import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/image_dto.dart';
import 'package:tolymoly/utils/dialog_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class SellImagePreview extends StatefulWidget {
  final ImageDto image;
  SellImagePreview({this.image});

  _SellImagePreviewState createState() => _SellImagePreviewState();
}

class _SellImagePreviewState extends State<SellImagePreview> {
  static const int indexDelete = 0;
  static const int indexReplace = 1;
  static const int indexEdit = 2;

  Widget _buildImage() {
    if (widget.image.asset != null) {
      double screenWidth = MediaQuery.of(context).size.width;
      int width = widget.image.asset.originalWidth;
      int height = widget.image.asset.originalHeight;
      double ratio = width / screenWidth;
      double newHeight = height / ratio;

      return AssetThumb(
        asset: widget.image.asset,
        width: screenWidth.toInt(),
        height: newHeight.toInt(),
      );
    } else {
      return widget.image.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Preview')),
        backgroundColor: ColorConstant.primary,
      ),
      // body: Image.file(widget.data['file']),
      // body: widget.image,
      body: Container(alignment: Alignment.center, child: _buildImage()),
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
          if (widget.image.filePath != null)
            BottomNavigationBarItem(
              icon: new Icon(Icons.edit),
              title: new Text(LocaleUtil.get('Edit')),
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
