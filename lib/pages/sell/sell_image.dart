import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tolymoly/dto/image_dto.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'dart:io';

import 'package:tolymoly/pages/sell/sell_image_preview.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class SellImage extends StatefulWidget {
  final images;
  final Function onSubmitImage;
  final bool isNew;
  SellImage.fromNew(this.onSubmitImage)
      : this.images = null,
        this.isNew = true;
  SellImage.fromEdit(this.onSubmitImage, this.images) : this.isNew = false;

  _SellImageState createState() => _SellImageState();
}

class _SellImageState extends State<SellImage> {
  // Logger logger = new Logger();

  // List<Asset> images = List<Asset>();
  List<ImageDto> images = List<ImageDto>();
  ImageDto currentImage;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() {
    if (widget.isNew) return;

    print(widget.images.length.toString());
    for (var i = 0; i < widget.images.length; i++) {
      int imageNo = widget.images[i]['no'];
      String imageUrl = widget.images[i]['url'];

      // editImages.insert(
      //     imageNo, new ImageModel(Image.network(imageUrl), '', imageUrl));

      images.insert(
          imageNo,
          new ImageDto(Image(image: new CachedNetworkImageProvider(imageUrl)),
              null, imageUrl, imageNo, null));
    }

    widget.onSubmitImage(images);

    // var i = jsonDecode(widget.data['image']);
    // logger.d(i[0].toString());

    // for (var i = 0; i < 8; i++) {
    //   if (widget.data['image'][i] != null) {
    //     if (widget.data['image'][i]['imageNo'] != null) {
    //       editImages.insert(i, widget.data['image'][i]['imageNo']);
    //     }
    //   }
    // }
  }

  Widget buildGridView() {
    // if (images == null) return SizedBox.shrink();
    int itemCount;
    if (images.length < 8) {
      itemCount = images.length + 1;
    } else {
      itemCount = 8;
    }

    return GridView.count(
      shrinkWrap: true,
      // physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      children: List.generate(itemCount, (index) {
        var image;
        // if (index > images.length - 1 || images[index] == null) {
        if (index == images.length) {
          image = Icon(
            Icons.camera_alt,
            color: Colors.grey,
            size: 30.0,
          );
        } else {
          // Asset asset = images[index];
          // image = AssetThumb(
          //   asset: asset,
          //   width: 300,
          //   height: 300,
          // );

          if (images[index].asset == null) {
            image = images[index].image;
          } else {
            image = AssetThumb(
              asset: images[index].asset,
              width: 150,
              height: 150,
            );
          }
        }

        return InkWell(
          onTap: () async {
            if (index < images.length) {
              // Asset asset = images[index];
              // String filePath = await editImages[index].filePath;
              // await _previewSelection(context, index, new File(filePath));
              // await _previewSelection(context, index, images[index].image);

              currentImage = images[index];
              // await _editImageDialog(context);

              await _preview(context, images[index]);

              widget.onSubmitImage(images);
            } else {
              await _pickImage();
              widget.onSubmitImage(images);
            }
          },
          child: image,
        );
      }),
    );
  }

  Future<void> _pickImage() async {
    print('pickImage...');

    int maxImage = 8 - images.length;

    // setState(() {
    //   images = List<Asset>();
    // });

    List<Asset> resultList;
    // String error;

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: maxImage, enableCamera: true);
    } on Exception catch (e) {
      print('MultiImagePicker > error...');
      print(e);
      // error = e.message;
    }

    if (resultList.length == 0) return;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    List<ImageDto> newImages = new List<ImageDto>();

    for (var i = 0; i < resultList.length; i++) {
      String filePath = await resultList[i].filePath;
      Asset asset = resultList[i];
      Image image = Image.file(new File(filePath));
      // ImageProvider imageProvider = FileImage(new File(filePath));
      int imageNo = images.length + i;
      ImageDto dto = new ImageDto(image, filePath, null, imageNo, asset);
      newImages.add(dto);
    }

    images = new List.from(images)..addAll(newImages);
    widget.onSubmitImage(images);

    setState(() {});
  }

  // Future<String> _editImageDialog(BuildContext context) async {
  //   return await showDialog<String>(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           // title: const Text('Edit'),
  //           children: <Widget>[
  //             if (currentImage.asset != null)
  //               SimpleDialogOption(
  //                 onPressed: () {
  //                   _onTapEditSelection('Edit');
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(LocaleUtil.get('Edit'),
  //                     style: TextStyle(fontSize: 18)),
  //               ),
  //             if (currentImage.asset != null) SizedBox(height: 20),
  //             SimpleDialogOption(
  //               onPressed: () {
  //                 _onTapEditSelection('Replace');
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(LocaleUtil.get('Replace'),
  //                   style: TextStyle(fontSize: 18)),
  //             ),
  //             SizedBox(height: 20),
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: FlatButton(
  //                 child: Text(LocaleUtil.get('CANCEL')),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void _onTapEditSelection(String selection) {
  //   if (selection == 'Replace') {
  //     replaceImage(currentImage.imageNo);
  //   } else if (selection == 'Edit') {
  //     _cropImage(File(currentImage.filePath));
  //   }
  // }

  Future<void> replaceImage(int index) async {
    List<Asset> resultList;

    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);
    } on Exception catch (e) {
      print('MultiImagePicker error...');
      print(e);
    }

    if (resultList.length == 0) return;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    String filePath = await resultList[0].filePath;

    _updateImage(filePath, resultList[0]);
  }

  void _updateImage(String filePath, Asset asset) {
    int index = currentImage.imageNo;
    Image image = Image.file(new File(filePath));
    ImageDto im = new ImageDto(image, filePath, null, index, asset);
    images[index] = im;
    setState(() {});
  }

  _preview(BuildContext context, ImageDto dto) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          // builder: (context) => SellImagePreview(data: {'file': file})),
          builder: (context) => SellImagePreview(image: dto)),
    );

    if (result == null) return;

    if (result['isDelete'] != null && result['isDelete']) {
      images.removeAt(currentImage.imageNo);
    } else if (result['isReplace'] != null && result['isReplace']) {
      replaceImage(currentImage.imageNo);
    } else if (result['isEdit'] != null && result['isEdit']) {
      _cropImage(File(currentImage.filePath));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        maxWidth: 512,
        maxHeight: 512,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ], androidUiSettings: AndroidUiSettings(
        toolbarTitle: LocaleUtil.get('Crop Photo'),
        toolbarColor: ColorConstant.primary,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    _updateImage(croppedFile.path, null);
  }

  @override
  Widget build(BuildContext context) {
    return buildGridView();
  }
}
