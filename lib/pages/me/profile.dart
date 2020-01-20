import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/pages/home/home_bottom_navigation.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/image_upload_utl.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'description.dart';
import 'package:tolymoly/api/user_api.dart';
import 'change_password.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:http/http.dart' as http;

import 'package:tolymoly/widgets/custom_button.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'user_name.dart';
class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  String _userName = '';

  String _phoneNo = '';
  String _fbMsgLink = '';
  var logger = new Logger();
  UserService userService = new UserService();
  TextEditingController updateNameController;
  TextEditingController updateFacebookMessengerLinkController;
  TextEditingController updatePhoneController;

  @override
  void initState() {
    // TODO: implement initState
    updateNameController = new TextEditingController();
    updateFacebookMessengerLinkController = new TextEditingController();
    updatePhoneController = new TextEditingController();
    updateFacebookMessengerLinkController.addListener(getFbMsgLink);
    updatePhoneController.addListener(getPhone);
    updateNameController.addListener(getUserName);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    updateNameController.dispose();
    updatePhoneController.dispose();
    updateFacebookMessengerLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocaleUtil.get('Profile'),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: userService.find(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return profileColumn(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('Fail');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  setting(UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      _bottomSheet(context);
                      // _choose();
                      // _getImage();
                    },
                    leading: Text(
                      LocaleUtil.get('Photo'),
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        user.image == null
                            ? Icon(Icons.person)
                            : Image.network(user.image),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black26,
                      height: 0.5,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Description(
                            user.description == null ? '' : user.description);
                      }));
                    },
                    title: Text(LocaleUtil.get('Description')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 160.0,
                          child: Text(
                            user.description == null ? '' : user.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black26,
                      height: 0.5,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return UserName(
                                user.username == null ? '' : user.username);
                          }));
                    },
                    title: Text(LocaleUtil.get('User name')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(user.username),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black26,
                      height: 0.5,
                    ),
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ChangePassword();
                        }));
                      },
                      title: Text(LocaleUtil.get('Password')),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black38,
                      )),
                ],
              ),
            ),
          ),
          settingOptinal(user),
        ],
      ),
    );
  }

  profileColumn(UserModel userModel) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            setting(userModel),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                height: 70.0,
                width: 300.0,
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, bottom: 15.0,),
                    child: CustomButton(
                        onPressed: () async {
                          await userService.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeBottomNavigation()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        text: LocaleUtil.get('Logout'),
                        buttonTypeEnum: ButtonTypeEnum.origin)),

              ),
            )
          ],
        ),
      ),
    );
  }

  _putPhNo(BuildContext context, String ph) {
    return AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Phone (separate by comma)'),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              controller: _phoneNo == ''
                  ? (updatePhoneController
                    ..text = ph
                    ..selection = TextSelection.collapsed(offset: ph?.length ?? 0))
                  : updatePhoneController
                ..text = _phoneNo
                ..selection = TextSelection.collapsed(offset: _phoneNo.length),
              onChanged: (text) {
                ph = text;
              },
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(LocaleUtil.get('Cancel')),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
        FlatButton(
          child: Text(LocaleUtil.get('Save')),
          onPressed: () {
            _updatePhNo(updatePhoneController.text);
          },
        )
      ],
    );
  }

  _putMessengerLink(BuildContext context, String msgLink) {
    return AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Facebook messenger link. (example:http://m.me/username)'),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextField(
              autofocus: true,
              controller: _fbMsgLink == ''
                  ? (updateFacebookMessengerLinkController
                    ..text = msgLink
                    ..selection =
                        TextSelection.collapsed(offset: msgLink?.length ?? 0))
                  : updateFacebookMessengerLinkController
                ..text = _fbMsgLink
                ..selection =
                    TextSelection.collapsed(offset: _fbMsgLink.length),
              onChanged: (text) {
                msgLink = text;
              },
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(LocaleUtil.get('Cancel')),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
        FlatButton(
          child: Text(LocaleUtil.get('Save')),
          onPressed: () {
            _updateFacebookMessengerLink(
                updateFacebookMessengerLinkController.text);
          },
        )
      ],
    );
  }

  Future _updatePhNo(String text) async {
    var response;
    response =
        await UserApi.putPhoneNo(text.replaceAll(new RegExp(r"\n|\ "), ""));

    if (response.statusCode == 200) {
      ToastUtil.success();
      _updateDatabase();
      _phoneNo = '';
      Navigator.of(context).pop();
    } else {
      ToastUtil.error('Fail');
    }
  }

  Future _updateFacebookMessengerLink(text) async {
    var response;
    response = await UserApi.putFacebookMessenger(
        text.replaceAll(new RegExp(r"\n|\ "), ""));

    if (response.statusCode == 200) {
      ToastUtil.success();
      _updateDatabase();
      _fbMsgLink = '';
      Navigator.of(context).pop();
    } else {
      ToastUtil.error('Fail');
    }
  }



  void _bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Wrap(children: <Widget>[
            ListTile(
                title: Text(LocaleUtil.get('Choose from')),
                trailing: GestureDetector(
                    child: Text(LocaleUtil.get('Close'),
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onTap: () => Navigator.pop(context))),
            ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(LocaleUtil.get('Camera')),
                onTap: () => _getImage(0)),
            ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(LocaleUtil.get('Album')),
                onTap: () => _getImage(1)),
          ]));
        });
  }

  Future _getImage(int index) async {
    Navigator.pop(context);
    ProgressIndicatorUtil.showProgressIndicator(context);
    var image = index == 0
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    ProgressIndicatorUtil.closeProgressIndicator();
    logger.d("image$image");
    _cropImage(image);
  }

  Future<Null> _cropImage(File imageFile) async {
    ProgressIndicatorUtil.showProgressIndicator(context);
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
    /*    ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        circleShape: true,
        toolbarTitle: LocaleUtil.get('Crop Photo'),
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white);*/

    logger.d(croppedFile.path);
    bool isSuccess = await uploadProfile(croppedFile.path);
    if (!isSuccess) return;

    _updateDatabase();

    ProgressIndicatorUtil.closeProgressIndicator();
  }

  void _updateDatabase() async {
    var responseData = await UserApi.getUserProfile();
    bool isUpdateDb = await userService.update(responseData);
    logger.d('isUpdateDb $isUpdateDb');

    if (!isUpdateDb) return;

    ProgressIndicatorUtil.closeProgressIndicator();

    setState(() {});
  }

  static Future<List<int>> compressFile(File file) async {
    int sizeBefore = file.lengthSync();
    var result = await FlutterImageCompress.compressWithFile(file.absolute.path,
        quality: 20);
    int sizeAfter = result.length;
    print('image compressed before: $sizeBefore , after: $sizeAfter');
    return result;
  }

  static Future<bool> uploadProfile(String imagePath) async {
    print('upload image...');
    var resUrl = await UserApi.getUploadUrl();

    List<int> compressedFile = await compressFile(new File(imagePath));

    var resUploadToS3 =
        await http.put(resUrl.data['imageUploadUrl'], body: compressedFile);

    if (resUploadToS3.statusCode == 200) {
      print('image > s3 : success');

      var resImageNo = await UserApi.putProfile();
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

  void getUserName() {
    _userName = updateNameController.text;
  }

  void getPhone() {
    _phoneNo = updatePhoneController.text;
  }

  void getFbMsgLink() {
    _fbMsgLink = updateFacebookMessengerLinkController.text;
  }

  settingOptinal(UserModel user) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.black12,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 26.0, top: 16.0, bottom: 8.0),
                    child: Text(
                      'Optinal contact for buyer to contact you',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Card(
                    child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Dialog();
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _putPhNo(context, user.phone));
                            },
                            title: Text(LocaleUtil.get('PhoneNo')),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 160.0,
                                  child: Text(
                                    user.phone == null ? '' : user.phone,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black38,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black26,
                              height: 0.5,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Dialog();
                              showDialog(
                                  context: context,
                                  builder: (context) => _putMessengerLink(
                                      context, user.facebookMessenger));
                            },
                            title: Text('Facebook Messenger'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 160.0,
                                  child: Text(
                                    user.facebookMessenger == null
                                        ? ''
                                        : user.facebookMessenger,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black38,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
