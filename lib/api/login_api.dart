import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class LoginApi {
  static final String url = '/login';

  static Future<Response> postFacebook(Map data) async {
    var conn = await HttpUtil.conn();
    return conn.post(url + '/facebook', data: data);
  }

  static Future<Response> postSms(Map data) async {
    var conn = await HttpUtil.conn();
    return conn.post(url + '/sms', data: data);
  }

  static Future<Response> postPassword(String username, String password) async {
    var conn = await HttpUtil.conn();
    return conn.post(url + '/password',
        data: {'username': username, 'password': password});
  }

  // static Future<Response> getOneByBuying(int adId, int sellerId) async {
  //   return await HttpUtil.connection().get(url + '/buying/chat-history',
  //       queryParameters: {'adId': adId, 'sellerId': sellerId});
  // }

  // static Future<Response> getOneBySelling(int adId, int buyerId) async {
  //   return await HttpUtil.connection().get(url + '/selling/chat-history',
  //       queryParameters: {'adId': adId, 'buyerId': buyerId});
  // }

  // static Future<Response> getBuying(int pageNumber) async {
  //   return await HttpUtil.connection()
  //       .get(url + '/buying', queryParameters: {'pageNumber': pageNumber});
  // }

  // static Future<Response> getSelling(int pageNumber) async {
  //   return await HttpUtil.connection()
  //       .get(url + '/selling', queryParameters: {'pageNumber': pageNumber});
  // }
}
