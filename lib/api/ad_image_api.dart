import 'package:dio/dio.dart';
import 'package:tolymoly/utils/http_util.dart';

class AdImageApi {
  static final String url = '/ads';

  static Future<Response> getUploadUrl(int adId, int imageNo) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.get(url + '/$adId/image-upload-url/$imageNo');
  }

  static Future<Response> put(int adId, int imageNo) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/$adId/images', data: {'imageNo': imageNo});
  }

  static Future<Response> putReorderImages(int adId, String data) async {
    var connAuth = await HttpUtil.connAuth();

    return connAuth.put(url + '/$adId/reorder-images', data: data);
  }
}
