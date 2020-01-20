import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/utils/http_util.dart';

class MyFavouriteApi {
  static final String url = '/my-favourite';

  static Future<Response> get(int pageNumber) async {
    var connAuth = await HttpUtil.connAuth();
    return connAuth.get(url, queryParameters: {'pageNumber': pageNumber});
  }

  static Future<Response> delete(Map data) async {
    var connAuth = await HttpUtil.connAuth();
    return connAuth.post(url + '/delete-my-favourites', data: data);
  }

  static Future<Response> addRemove(int adId) async {
    var connAuth = await HttpUtil.connAuth();
    return connAuth.post(url + '/add-remove', data: {'adId': adId});
  }
}
