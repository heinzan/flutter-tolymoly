import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/utils/http_util.dart';

class UserReportApi {
  static final String url = '/report/users';

  static Future<Response> post(Map data) async {
    var connAuth = await HttpUtil.connAuth();
    return connAuth.post(url, data: data);
  }
}
