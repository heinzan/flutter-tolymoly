import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tolymoly/dto/image_dto.dart';
import 'package:tolymoly/models/ad_image.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class SellImageGallery extends StatefulWidget {
  SellImageGallery(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      @required this.image})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  // final List<GalleryExampleItem> galleryItems;
  final ImageDto image;

  @override
  State<StatefulWidget> createState() {
    return _SellImageGalleryState();
  }
}

class _SellImageGalleryState extends State<SellImageGallery> {
  int currentIndex;
  static const int indexDelete = 0;
  static const int indexReplace = 1;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Preview')),
      ),
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: 1,
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),

              // Container(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     "${currentIndex + 1}/${widget.adImageModels.length}",
              //     style: const TextStyle(
              //         color: Colors.white, fontSize: 17.0, decoration: null),
              //   ),
              // )
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: 0, // this will be set when a new tab is tapped
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
        onTap: (index) {
          switch (index) {
            case indexDelete:
              Navigator.pop(context, {'isDelete': true});
              break;
            case indexReplace:
              Navigator.pop(context, {'isReplace': true});
              break;
          }
        },
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    // final GalleryExampleItem item = widget.imageUrls[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: _getImageProvider(widget.image),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      // heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

  _getImageProvider(ImageDto dto) {
    if (dto.url != null) {
      return NetworkImage(dto.url);
    } else if (dto.asset != null) {
      return FileImage(File(dto.filePath));
    }
  }
}
