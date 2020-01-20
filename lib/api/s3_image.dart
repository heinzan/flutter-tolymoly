import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class S3ImageApi {
  static Future<Response> put(String url, var data) async {
    var conn = await HttpUtil.conn();

    return conn.put(url, data: data);
  }
}
