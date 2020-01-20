import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/utils/toast_util.dart';

class HttpUtil {
  // static final String token =
  //     "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxIiwiaWF0IjoxNTY2NTUyMDE5LCJleHAiOjE1OTgxMDg5NzF9.pCvl75_UvoXaNEHYc6WP0NpKrHk5YCB-iHCpSZwHnCQ";

  // static final url = "http://192.168.88.25:8080/api";
  static final url = "https://api.bagayar.club/api";

  static Dio dio;
  static String token;
  static Logger logger = new Logger();
  static bool isZawgyi = true;
  // static UserService _userService = UserService();

  // HttpConnection() {
  //   print("init HttpConnection");

  //   if (dio == null) {
  //     init();
  //   }
  // }

  static conn() async {
    return await _getDio(false);
  }

  static connAuth() async {
    return await _getDio(true);
  }

  static bool validateResponse(Response response) {
    if (response == null) ToastUtil.error('No internet');

    int code = response.statusCode;

    if (code == 200) return true;

    switch (code) {
      case 401:
        ToastUtil.error('Please login first');
        break;
      case 403:
        ToastUtil.error('No permission');
        break;
      case 404:
        ToastUtil.error('Resource not found');
        break;
      default:
        ToastUtil.error('Error code: $code ');
        break;
    }

    return false;
  }

  static _getDio(bool isTokenRequired) async {
    if (dio == null) {
      _initDio();
    }

    await _setAuth(isTokenRequired);

    return dio;
  }

  static _setAuth(bool isTokenRequired) async {
    // print("_setAuth...");

    // String token = isTokenRequired ? await _getToken() : '';
    // print("token:");
    // print(token);

    if (isTokenRequired) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
      // dio.options.headers['Authorization'] = '';
    }

    // dio.options.headers["Authorization"] = "Bearer $token";
    // dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
    //   //Set the token to headers
    //   options.headers['Authorization'] = headerToken;

    //   return options; //continue
    // }));
  }

  // static Future<String> _getToken() async {
  //   print("_getToken...");

  //   if (token == null) {
  //     print("token == null...");

  //     // token = await storage.read(key: 'token');
  //     // token = await AuthUtil.getToken();

  //     token = await _userService.findToken();

  //     if (token == null) {
  //       ToastUtil.error('token is null');
  //     }
  //   }

  //   return token;
  // }

  static Dio _initDio() {
    // print("init dio...");
    // final prefs = await SharedPreferences.getInstance();
    // final key = 'token';
    // final token = prefs.getString(key) ?? '';

    dio = new Dio();

    // Set default configs
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;

    // dio.interceptors.add(LogInterceptor(requestHeader: true));
    // dio.interceptors.add(LogInterceptor(requestHeader: true));
    // dio.interceptors.add(LogInterceptor(request: true));
    // dio.interceptors.add(LogInterceptor(requestBody: true));
    // dio.interceptors.add(LogInterceptor(responseBody: true));

    dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) {
      ProgressIndicatorUtil.closeProgressIndicator();

      print('e.response: ${e.response}');
      print('e.message: ${e.message}');
      print('e.type: ${e.type}');
      // logger.d(e.request.data);
      // logger.d(e.response);
      // logger.d(e.message);
      // logger.d(e.type);

      if (e.type == DioErrorType.DEFAULT &&
          e.message.contains('Failed host lookup')) {
        ToastUtil.error('No internet');
      } else {
        validateResponse(e.response);
      }

      return e; //continue
    }));

    return dio;
  }
}
