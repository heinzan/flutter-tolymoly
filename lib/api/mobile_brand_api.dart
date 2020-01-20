import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class MobileBrandApi {
  static final String url = '/phone-brands/';

  static Future<Response> get() async {
    var conn = await HttpUtil.conn();

    return conn.get(url);
  }

  static Future<Response> getModel(int mobileBrandId) async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '$mobileBrandId/models');
  }
}
