import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class AdReportApi {
  static final String url = '/report';

  static Future<Response> post(Map data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.post(url, data: data);
  }
}
