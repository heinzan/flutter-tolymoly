import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tolymoly/models/ad_image.dart';

class BuyImage extends StatefulWidget {
  BuyImage(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      @required this.adImageModels})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  // final List<GalleryExampleItem> galleryItems;
  final List<AdImageModel> adImageModels;

  @override
  State<StatefulWidget> createState() {
    return _BuyImageState();
  }
}

class _BuyImageState extends State<BuyImage> {
  int currentIndex;
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
        backgroundColor: Colors.black,
        title: Text(
          "${currentIndex + 1}/${widget.adImageModels.length}",
          style: const TextStyle(
              color: Colors.white, fontSize: 17.0, decoration: null),
        ),
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
                itemCount: widget.adImageModels.length,
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
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    // final GalleryExampleItem item = widget.imageUrls[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(widget.adImageModels[index].imageUrl),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      // heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}
