import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:async';

import 'package:tolymoly/api/ad_api.dart';
import 'package:tolymoly/api/ad_image_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/dto/image_dto.dart';
import 'package:tolymoly/enum/ad_button_enum.dart';
import 'package:tolymoly/enum/ad_status_enum.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/ad_image.dart';
import 'package:tolymoly/pages/sell/sell_form_field.dart';
import 'package:tolymoly/pages/sell/sell_image.dart';
import 'package:tolymoly/utils/dialog_util.dart';
import 'package:tolymoly/utils/image_upload_utl.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:tolymoly/utils/user_preference_util.dart';

class SellForm extends StatefulWidget {
  final int adId;
  final bool isNewAd;
  final CategoryPickerDto categoryPickerDto;

  SellForm.fromCategory(this.categoryPickerDto)
      : adId = null,
        this.isNewAd = true;

  SellForm.edit(this.adId)
      : categoryPickerDto = null,
        this.isNewAd = false;

  @override
  _SellFormState createState() {
    return _SellFormState();
  }
}

class _SellFormState extends State<SellForm> {
  var logger = Logger();

  // List<Asset> images = List<Asset>();
  List<AdImageModel> images = List<AdImageModel>();
  List<ImageDto> updatedImages = List<ImageDto>();
  dynamic adData;
  bool isDataLoaded = false;
  bool isProgress = false;

  @override
  void initState() {
    _initForm();
    super.initState();
  }

  // _init() async {
  //   await _initForm();
  // }

  _initForm() async {
    print('_initForm');

    if (widget.isNewAd) {
      // adData['categoryId'] = widget.categoryPickerDto.id;

      var response = await AdApi.getAdd(
          UserPreferenceUtil.displayLanguageTypeEnum.index,
          widget.categoryPickerDto.id);
      adData = response.data;
    } else {
      // var response = await AdApi.getShow(
      //     widget.adId, UserPreferenceUtil.displayLanguageTypeEnum.index);

      // adDetailModel = AdDetailModel.fromMap(response.data);

      var response = await AdApi.getEdit(
          widget.adId, UserPreferenceUtil.displayLanguageTypeEnum.index);

      if (response.statusCode != 200) return;

      adData = response.data;

      // images = AdDetailModel.fromMap(response.data).image;

      logger.d(adData.toString());
      // print(adData['image'].toString());
    }

    print('_initForm > setState ');

    isDataLoaded = true;

    setState(() {});

    print('_initForm > setState > end');
  }

  onSubmitImage(List<ImageDto> updatedImages) {
    print('imageCallback...');
    // images = updatedImages;
    _logImage();

    this.updatedImages = updatedImages;
  }

  onSubmitForm(AdButtonEnum enumValue, String data) async {
    print('formCallback...');
    if (_isImageEmpty()) return;

    ProgressIndicatorUtil.showProgressIndicator(context);

    var response;
    bool isImageSuccess = false;
    int adId = widget.adId;
    bool showPendingText = false;
    switch (enumValue) {
      case AdButtonEnum.post:
        response = await AdApi.post(data);
        if (response.statusCode != 200) return;

        isImageSuccess = await _processImage(response.data);
        showPendingText = true;
        break;
      case AdButtonEnum.update:
        response = await AdApi.put(adId, data);
        if (response.statusCode != 200) return;

        isImageSuccess = await _processImage(response.data);
        showPendingText = true;

        break;
      case AdButtonEnum.draft:
        response = await AdApi.postSaveAsDraft(data);
        if (response.statusCode != 200) return;

        isImageSuccess = await _processImage(response.dat);
        break;
      case AdButtonEnum.delete:
        response = await AdApi.delete(adId);
        break;
      case AdButtonEnum.deactivate:
        response = await AdApi.putStatus(adId, AdStatusEnum.inactive);
        break;
      case AdButtonEnum.active:
        response = await AdApi.putStatus(adId, AdStatusEnum.active);
        break;
      case AdButtonEnum.markAsSold:
        response = await AdApi.putStatus(adId, AdStatusEnum.sold);
        break;
    }

    ProgressIndicatorUtil.closeProgressIndicator();

    if (isImageSuccess || response.statusCode == 200) {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => SellSuccess(showPendingText)),
      //   (Route<dynamic> route) => false,
      // );
      Navigator.pushNamed(context, RouteConstant.sellSuccess,
          arguments: showPendingText);
    }
  }

  bool _isImageEmpty() {
    if (updatedImages.length == 0) {
      ToastUtil.error('Image cannot be empty');
      return true;
    }
    return false;
  }

  _logImage() {
    for (int i = 0; i < updatedImages.length; i++) {
      String imageNo = updatedImages[i].imageNo.toString();
      String url = updatedImages[i].url;
      String path = updatedImages[i].filePath;
      print('updatedImages > imageNo: $imageNo: $url, $path');
    }
  }

  Future<bool> _processImage(int adId) async {
    _logImage();

    String updatedData = '';
    for (int i = 0; i < updatedImages.length; i++) {
      ImageDto dto = updatedImages[i];
      if (dto.filePath != null && dto.filePath.isNotEmpty) {
        bool isSuccess = await uploadImage(adId, dto.imageNo, dto.filePath);
        if (!isSuccess) return false;
      } else {
        updatedData = updatedData +
            '{"imageNo":${dto.imageNo}, "imageUrl":"${dto.url}"},';
      }
    }

    if (images.length > updatedImages.length) {
      int deletedCount = images.length - updatedImages.length;
      for (int i = 0; i < deletedCount; i++) {
        int imageNo = images.length - 1 - i;
        updatedData = updatedData + '{"imageNo":$imageNo, "imageUrl":null},';
      }
    }

    if (updatedData.endsWith(','))
      updatedData = updatedData.substring(0, updatedData.length - 1);

    if (updatedData.isNotEmpty) {
      updatedData = '[$updatedData]';
      print(updatedData);
      var response = await AdImageApi.putReorderImages(adId, updatedData);
      if (response.statusCode != 200) return false;
    }

    return true;
  }

  Future<bool> uploadImage(int adId, int imageNo, String imagePath) async {
    print('upload image...');

    var resUrl = await AdImageApi.getUploadUrl(adId, imageNo);

    List<int> compressedFile =
        await ImageUploadUtil.compressFile(File(imagePath));

    var resUploadToS3 = await http.put(resUrl.data['imageUploadUrl'],
        body: compressedFile); // cannot use dio here, not sure why

    if (resUploadToS3.statusCode == 200) {
      print('image > s3 : success');

      var resImageNo = await AdImageApi.put(adId, imageNo);
      if (resImageNo.statusCode == 200) {
        print('image no > backend : success');
        return true;
      }
    } else {
      print('image > s3 : error');
      print(resUploadToS3.body);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    print('build...');
    String title;
    if (widget.isNewAd) {
      if (UserPreferenceUtil.displayLanguageTypeEnum ==
          DisplayLanguageTypeEnum.English) {
        title = widget.categoryPickerDto.name;
      } else {
        title = widget.categoryPickerDto.mmUnicode;
      }
    } else {
      title = LocaleUtil.get(LabelConstant.edit);
    }

    return WillPopScope(
        onWillPop: () async {
          return DialogUtil.confirmation(
              context, LocaleUtil.get('Discard any changes to this Ad?'));
        },
        child: Scaffold(
            appBar: new AppBar(
              // title: new Text(widget.data['categoryName']),
              title: new Text(title),
              iconTheme: IconThemeData(
                color: ColorConstant.appBarIcon,
              ),
              backgroundColor: ColorConstant.primary,
            ),
            body: Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!isDataLoaded)
                        Center(child: CircularProgressIndicator()),
                      if (isDataLoaded) _buildImage(),
                      if (isDataLoaded) _buildFormField()
                    ],
                  ),
                ))));
  }

  Widget _buildImage() {
    if (widget.isNewAd) {
      return SellImage.fromNew(onSubmitImage);
    } else {
      return SellImage.fromEdit(onSubmitImage, adData['images']);
    }
  }

  Widget _buildFormField() {
    if (widget.isNewAd) {
      return SellFormField.fromNew(
          widget.categoryPickerDto.id, adData, onSubmitForm);
    } else {
      return SellFormField.fromEdit(widget.adId, adData, onSubmitForm);
    }
  }

  // Future<bool> _discardAlert(BuildContext context) async {
  //   return showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button for close dialog!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(LocaleUtil.get('Discard any changes to this Ad?')),
  //         content: const Text(''),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: const Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //             },
  //           ),
  //           FlatButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop(true);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
