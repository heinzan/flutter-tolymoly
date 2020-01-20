import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/chat_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/pages/auth/auth_tab.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';
import 'package:tolymoly/pages/chat/chat_tab.dart';
import 'package:tolymoly/pages/favourite/favourite.dart';
import 'package:tolymoly/pages/me/me.dart';
import 'package:tolymoly/pages/sell/sell_category_picker.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/chat_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:async/async.dart';
import 'package:tolymoly/utils/toast_util.dart';

class HomeBottomNavigation extends StatefulWidget {
  // int index;
  // bool showMyAds = false;
  HomeBottomNavigation();

  // HomeBottomNavigation.fromAdSubmit() : this.showMyAds = true;

  @override
  _HomeBottomNavigationState createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends State<HomeBottomNavigation>
    with WidgetsBindingObserver {
  DateTime currentBackPressTime = DateTime.now();
  Logger logger = new Logger();
  int unreadCount = 0;
  static RestartableTimer timer;

  int _currentIndex = 0;
  static const _indexHome = 0;
  static const _indexChat = 1;
  static const _indexSell = 2;
  static const _indexFavourite = 3;
  static const _indexMe = 4;

  int currentLargestMsgId = 0;
  // StreamController<Map<String, dynamic>> notificationStreamController =
  //     new StreamController();
  bool isPeriodicUnreadCountStarted = false;
  int unreadCountIntervalSeconds = 30;
  StreamSubscription streamSubscription;
  final BuyAdList buyAdList = new BuyAdList.fromHome();
  static final Me me = new Me();

  // List<Widget> _pages = [];
  IndexedStack indexedStack;

  @override
  initState() {
    super.initState();
    print('home > bottom navigation > inistate........');

    if (ChatUtil.hasFcmToken) {
      _setPushNotification();
      _updateUnreadCountFcm();
    } else {
      _startUnreadCount();

      // ChatUtil.periodicUnreadCount();
      // periodicUnreadCount();

      // print('register unreadStreamController........');
      // unreadStreamController.stream.listen((unreadCount) {
      //   print("111 unreadStreamController: " + unreadCount.toString());
      // }, onDone: () {
      //   print("Task Done1");
      // }, onError: (error) {
      //   print("Some Error1");
      // });
    }
    // _setPages();

    // _setIndexedStack();

    // _setPage();
  }

  @override
  void dispose() {
    print('home > bottom navi > dispose...');
    _stopPeriodicUnreadCount();
    streamSubscription.cancel();
    super.dispose();
  }

  // void _stopTimer() {
  //   if (timer != null) timer.cancel();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed...');
        break;
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive...');
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused...');
        break;
      case AppLifecycleState.suspending:
        print('AppLifecycleState.suspending...');
        break;
    }
  }

  // void _setPages() {
  //   _pages = [buyAdList, ChatTab(), SellCategoryPicker(), Favourite(), me];
  // }

  // void _setIndexedStack() {
  //   indexedStack = IndexedStack(index: widget.currentIndex, children: <Widget>[
  //     BuyAdList.fromHome(),
  //     ChatTab(),
  //     SellCategoryPicker(),
  //     Favourite(),
  //     Me()
  //   ]);
  // }

  void _startUnreadCount() {
    if (!AuthUtil.isLoggedIn) return;
    if (ChatUtil.hasFcmToken) return;
    if (isPeriodicUnreadCountStarted) return;

    _periodicUnreadCount();
  }

  void _periodicUnreadCount() async {
    print('periodicUnreadCount...');
    isPeriodicUnreadCountStarted = true;

    _stopPeriodicUnreadCount();
    int newUnreadCount = await _getUnreadCount();
    if (newUnreadCount != unreadCount) {
      unreadCount = newUnreadCount;
      setState(() {});
    }

    _startTimer();
  }

  void _startTimer() {
    print('home > bottom navigation > _startTimer...');
    timer = new RestartableTimer(
        Duration(seconds: unreadCountIntervalSeconds), _periodicUnreadCount);
  }

  void _stopPeriodicUnreadCount() {
    if (timer != null) timer.cancel();
    isPeriodicUnreadCountStarted = false;
  }

  Future<int> _getUnreadCount() async {
    if (!AuthUtil.isLoggedIn) return 0;

    Response response = await ChatApi.getTotalUnreadCount();
    int count = response.data['totalUnreadCount'];
    return count;
  }

  // _setUnreadCount(int unreadCount) {
  //   unreadStreamController.add(unreadCount);
  // }

  // void _setPage() {
  //   if (widget.showMyAds) {
  //     _pages[_indexMe] = MyAds();
  //   } else {
  //     _pages[_indexMe] = me;
  //   }
  // }

  void _setPushNotification() async {
    logger.d('home > _setPushNotification...');
    // ChatUtil.setNotification(_onNotification);
    ChatUtil.setNotification();
    streamSubscription =
        ChatUtil.notificationStreamController.stream.listen((message) {
      print('1======================');
      print("home > notificationStreamController: " + message.toString());
      print('======================');
      unreadCount = int.parse(message['data']['unreadCount']);
      setState(() {});
    });
  }

  void _updateUnreadCountFcm() async {
    int newUnreadCount = await _getUnreadCount();
    if (newUnreadCount != unreadCount) {
      unreadCount = newUnreadCount;
      setState(() {});
    }
  }

  // void _onNotification(Map<String, dynamic> message) {
  //   int notificationMessageId = int.parse(message['data']['messageId']);
  //   if (notificationMessageId > currentLargestMsgId) {
  //     currentLargestMsgId = notificationMessageId;
  //     int notificationUnreadCount = int.parse(message['data']['unreadCount']);
  //     unreadCount = notificationUnreadCount;
  //     setState(() {});
  //   }
  // }

  // void _getUnreadCount() async {
  //   if (!AuthUtil.isLoggedIn) return;
  //   Response response = await ChatApi.getTotalUnreadCount();
  //   if (response.statusCode != 200) return;
  //   unreadCount = response.data['totalUnreadCount'];

  //   setState(() {});
  // }

  // void _setLargestId(int latestMsgId) {
  //   if (latestMsgId > currentLargestMsgId) {
  //     currentLargestMsgId = latestMsgId;
  //   }
  // }

  onTabTapped(int index) {
    // if (index == _indexHome) {
    //   _startPeriodicUnreadCount();
    // } else {
    //   _stopPeriodicUnreadCount();
    // }

    switch (index) {
      case _indexHome:
        _currentIndex = index;
        setState(() {});
        break;
      case _indexChat:
        bool isAtuh = AuthUtil.validate(context);

        if (!isAtuh) return;

        // widget.currentIndex = index;
        // setState(() {});

        Navigator.of(context)
            .push(
          new MaterialPageRoute(builder: (context) => ChatTab()),
        )
            .then((val) async {
          // _startPeriodicUnreadCount();
          // _setPushNotification();
          _currentIndex = _indexHome;

          if (ChatUtil.hasFcmToken) {
            _updateUnreadCountFcm();
          }
        });

        break;
      case _indexFavourite:
        bool isAtuh = AuthUtil.validate(context);

        if (!isAtuh) return;

        // widget.currentIndex = index;

        // setState(() {});

        Navigator.of(context)
            .push(
          new MaterialPageRoute(builder: (context) => Favourite()),
        )
            .then((val) async {
          // _startPeriodicUnreadCount();
          // _setPushNotification();
          _currentIndex = _indexHome;
        });
        break;
      case _indexSell:
        // this button is below the floating camera button, so do nothing
        break;
      case _indexMe:

        // widget.showMyAds = false;
        // _setPage();

        _currentIndex = index;

        setState(() {});
        break;
    }
  }

  // bool _validateAuth() {
  //   if (!AuthUtil.isLoggedIn) {
  //     Navigator.of(context).pushNamed(RouteConstant.authTab);

  //     return false;
  //   }
  //   return true;
  // }

  // Widget _buildBody() {
  //   print('home > bottom navigation > _buildBody...');
  //   return IndexedStack(index: currentIndex, children: <Widget>[
  //     BuyAdList.fromHome(),
  //     ChatList.all(),
  //     SellCategoryPicker(),
  //     Favourite(),
  //     Me()
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    print('home > bottom navigation > build...');

    ModalRoute.of(context).isCurrent
        ? _startUnreadCount()
        : _stopPeriodicUnreadCount();

    return WillPopScope(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Tolymoly'),
          // ),
          body: IndexedStack(index: _currentIndex, children: <Widget>[
            BuyAdList.fromHome(),
            SizedBox.shrink(),
            SizedBox.shrink(),
            SizedBox.shrink(),
            Me()
          ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorConstant.primary,
            onPressed: () {
              bool isAtuh = AuthUtil.validate(context);
              if (!isAtuh) return;
              // if (!_validateAuth()) return;

              // _stopPeriodicUnreadCount();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SellCategoryPicker()),
              // );

              // Navigator.of(context).pushNamed(RouteConstant.sellCategoryPicker);
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings:
                      RouteSettings(name: RouteConstant.sellCategoryPicker),
                  builder: (context) => SellCategoryPicker(),
                ),
              );
            },
            // tooltip: 'Increment',
            child: new Icon(Icons.camera_enhance),
            elevation: 2.0,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: ColorConstant.primary,
            onTap: onTabTapped,
            currentIndex:
                _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text(LocaleUtil.get('Home')),
              ),
              BottomNavigationBarItem(
                // icon: new Icon(Icons.chat_bubble_outline),
                // title: new Text('Chat'),
                icon: Stack(
                  children: <Widget>[
                    Icon(Icons.chat_bubble_outline),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                  ],
                ),
                title: Text(LocaleUtil.get('Chat')),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.favorite),
                title: new Text(LocaleUtil.get('Sell')),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.favorite_border),
                title: new Text(LocaleUtil.get('Favourite')),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  title: Text(LocaleUtil.get('Me')))
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
        onWillPop: onWillPop);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ToastUtil.info(LocaleUtil.get('Exit')); // you can use snackbar too here
      return Future.value(false);
    }
    return Future.value(true);
  }
}
