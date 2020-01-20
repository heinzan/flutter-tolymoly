import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class ChatApi {
  static final String url = '/chats';

  static Future<Response> post(Map data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.post(url, data: data);
  }

  static Future<Response> getOneByBuying(
      int adId, int sellerId, int messageId) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url + '/detail/buying', queryParameters: {
      'adId': adId,
      'sellerId': sellerId,
      'messageId': messageId
    });
  }

  static Future<Response> getOneBySelling(
      int adId, int buyerId, int messageId) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url + '/detail/selling', queryParameters: {
      'adId': adId,
      'buyerId': buyerId,
      'messageId': messageId
    });
  }

  static Future<Response> get(int pageNumber) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url, queryParameters: {'pageNumber': pageNumber});
  }

  static Future<Response> getBuying(int pageNumber) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth
        .get(url + '/buying', queryParameters: {'pageNumber': pageNumber});
  }

  static Future<Response> getSelling(int pageNumber) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth
        .get(url + '/selling', queryParameters: {'pageNumber': pageNumber});
  }

  static Future<Response> getTotalUnreadCount() async {
    Dio connAuth = await HttpUtil.connAuth();
    // set token again here else too many no tokn request at home page
    connAuth.options.headers['Authorization'] = 'Bearer ${HttpUtil.token}';

    return connAuth.get(url + '/totalUnreadCount');
  }

  static Future<Response> getUploadUrl(int adId, int receiverId) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url + '/image-url',
        queryParameters: {'adId': adId, 'receiverId': receiverId});
  }
}
