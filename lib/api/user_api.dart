import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/utils/burmese_util.dart';

class UserApi {
  static final String url = '/users/profile';

  static Future<Response> getProfile() async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url);
  }

  static Future<UserModel> getUserProfile() async {
    final res = await UserApi.getProfile();

    var jsonData = res.data;
    var map = Map<String, dynamic>.from(jsonData);
    var response = UserModel.fromJson(map);
    if (res.statusCode != 200) return null;

    return response;
  }

  static Future<Response> getSellerProfile(int sellerId) async {
    var conn = await HttpUtil.conn();

    return conn.get('/users/sellerProfile/$sellerId');
  }

  static Future<Response> putDescription(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/description',
        data: {"description": BurmeseUtil.toUnicode(data)});
  }

  static Future<Response> putName(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/username', data: {"username": data});
  }

  static Future<Response> putPassword(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/password', data: {"password": data});
  }

  static Future<Response> putFacebookMessenger(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth
        .put(url + '/facebook-messenger', data: {"facebookMessenger": data});
  }

  static Future<Response> getUploadUrl() async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url + '/image-upload-url');
  }

  static Future<Response> putProfile() async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/image');
  }

  static Future<Response> putFcmToken(bool hasToken, String token) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth
        .put(url + '/token', data: {'hasToken': hasToken, 'token': token});
  }

  static Future<Response> putPhoneNo(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth
        .put(url + '/phone', data: {"phone": data});
  }

}
