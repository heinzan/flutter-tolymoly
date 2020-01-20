import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class MyAdsApi {
  static final String url = '/my-ads';

  static Future<Response> getMyAds(String status, int pageNumber) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url,
        queryParameters: {'status': status, 'pageNumber': pageNumber});
  }
}
