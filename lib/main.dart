import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/pages/auth/auth_tab.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';
import 'package:tolymoly/pages/home/home_bottom_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/pages/me/my_ads.dart';
import 'package:tolymoly/pages/sell/sell_category_picker.dart';
import 'package:tolymoly/pages/sell/sell_form.dart';
import 'package:tolymoly/pages/sell/sell_success.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/initial_setup_util.dart';

final UserPreferenceService userPreferenceService = new UserPreferenceService();
UserService userService = new UserService();

// void main() => runApp(MyApp());
void main() async {
  await InitialSetupUtil.setup();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ColorConstant.primary, // navigation bar color
      statusBarColor: ColorConstant.statusBar // status bar color
      ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      title: 'Tolymoly',
      onGenerateRoute: _routes(),
      initialRoute: RouteConstant.homeBottomNavigation,
      debugShowCheckedModeBanner: false,
    ));
  }

  RouteFactory _routes() {
    return (settings) {
      // final Map<String, dynamic> arguments = settings.arguments;
      Widget page;
      switch (settings.name) {
        case RouteConstant.authTab:
          page = AuthTab();
          break;
        case RouteConstant.homeBottomNavigation:
          page = HomeBottomNavigation();
          break;
        case RouteConstant.sellCategoryPicker:
          page = SellCategoryPicker();
          break;
        case RouteConstant.sellFormFromCategory:
          page = SellForm.fromCategory(settings.arguments);
          break;
        case RouteConstant.sellSuccess:
          page = SellSuccess(settings.arguments);
          break;
        case RouteConstant.buyAdListFromSearchBar:
          page = BuyAdList.fromSearchBar(settings.arguments);
          break;
        case RouteConstant.myads:
          page = MyAds();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => page);
    };
  }
}
