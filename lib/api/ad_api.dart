import 'package:dio/dio.dart';
import 'package:tolymoly/enum/ad_status_enum.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/http_util.dart';

class AdApi {
  static final String url = '/ads';

  static Future<Response> get(String query) async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '?$query');
  }

  static Future<Response> getOne(int adId) async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '/$adId');
  }

  static Future<Response> getIndex(int pageNumber) async {
    var conn = await HttpUtil.conn();

    return conn
        .get(url + '/index', queryParameters: {'pageNumber': pageNumber});
  }

  static Future<Response> getAdd(int languageId, int categoryId) async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '/add',
        queryParameters: {'languageId': languageId, 'categoryId': categoryId});
  }

  static Future<Response> getShow(int adId, int languageId) async {
    var conn = await HttpUtil.connAuth();

    return conn
        .get(url + '/$adId/show', queryParameters: {'languageId': languageId});
  }

  static Future<Response> getEdit(int adId, int languageId) async {
    var conn = await HttpUtil.connAuth();

    return conn
        .get(url + '/$adId/edit', queryParameters: {'languageId': languageId});
  }

  static Future<Response> getIndexAdList() async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '/index/adList');
  }

  static Future<Response> getSellerAds(int userId, int pageNumber) async {
    var conn = await HttpUtil.conn();

    return conn.get(url + '/sellerAds',
        queryParameters: {'userId': userId, 'pageNumber': pageNumber});
  }

  static Future<Response> post(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.post(url, data: BurmeseUtil.toUnicode(data));
  }

  static Future<Response> postSaveAsDraft(String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.post('$url/save-as-draft',
        data: BurmeseUtil.toUnicode(data));
  }

  static Future<Response> put(int id, String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put('$url/$id', data: BurmeseUtil.toUnicode(data));
  }

  static Future<Response> delete(int id) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.delete('$url/$id');
  }

  static Future<Response> putStatus(int id, AdStatusEnum status) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put('$url/status/$id', data: {'status': status.index});
  }

  static Future<Response> getCompare(String query) async {
    var conn = await HttpUtil.conn();
    print(('$url/compare-phones?$query'));
    return conn.get('$url/compare-phones?$query');
  }
}
