import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tolymoly/api/user_api.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:async/async.dart';

class ChatUtil {
  // static int latestMessageId = 0;
  static int unreadCount = 0;
  static bool hasFcmToken = false;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static RestartableTimer timer;
  // static int refreshIntervalSeconds = 5;
  // static StreamController<int> unreadStreamController = new StreamController();
  static StreamController<Map<String, dynamic>> notificationStreamController =
      new StreamController.broadcast();
  static Future<bool> setToken() async {
    String token = await getTokn();

    hasFcmToken = token == null ? false : true;

    Response response = await UserApi.putFcmToken(hasFcmToken, token);

    if (response.statusCode != 200) return false;

    return true;
  }

  static Future<String> getTokn() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  // static _startTimer() {
  //   _stopTimer();
  //   print('1 _startTimer...');
  //   timer = new RestartableTimer(Duration(seconds: 5), periodicUnreadCount);
  // }

  // static _stopTimer() {
  //   if (timer != null) timer.cancel();
  // }

  // static periodicUnreadCount() async {
  //   print('periodicUnreadCount...');
  //   int unreadCount = await _getUnreadCount();
  //   _setUnreadCount(unreadCount);
  //   _startTimer();
  // }

  // static _getUnreadCount() async {
  //   print('_getUnreadCount...');

  //   Response response = await ChatApi.getTotalUnreadCount();
  //   int count = response.data['totalUnreadCount'];
  //   return count;
  // }

  // static _setUnreadCount(int unreadCount) {
  //   print('11 _setUnreadCount==========================...');

  //   unreadStreamController.add(unreadCount);
  // }

  // static void setNotification(Function _onNotification) {
  //   if (!hasFcmToken) return;

  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //       ToastUtil.info(LocaleText.youHaveNewMessage);
  //       _onNotification(message);
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //       _onNotification(message);
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //       _onNotification(message);
  //     },
  //   );
  // }

  static _onNotification(Map<String, dynamic> message) {
    notificationStreamController.add(message);
  }

  static void setNotification() {
    if (!hasFcmToken) return;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        ToastUtil.info(LabelConstant.youHaveNewMessage);
        _onNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        _onNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        _onNotification(message);
      },
    );
  }
}
