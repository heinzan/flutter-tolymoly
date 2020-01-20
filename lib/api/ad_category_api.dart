import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class AdCategoryApi {
  static final String url = '/ads/categories/list';

  static Future<Response> get() async {
    var conn = await HttpUtil.conn();

    return conn.get(url);
  }
}
