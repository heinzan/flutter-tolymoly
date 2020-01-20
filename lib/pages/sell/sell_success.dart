import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class SellSuccess extends StatelessWidget {
  final bool showPendingText;

  SellSuccess(this.showPendingText);
  // SellSuccess();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleUtil.get('Successful')),
            backgroundColor: ColorConstant.primary,
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(
                height: 10,
              ),
              if (showPendingText)
                Text(LocaleUtil.get('VerifiedMsg'),
                    style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: LocaleUtil.get('Sell another item'),
                buttonTypeEnum: ButtonTypeEnum.primary,
                onPressed: () {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => SellCategoryPicker()),
                  //   ModalRoute.withName('/home/home_bottom_navigation'),
                  // );

                  // int count = 0;
                  // Navigator.of(context).popUntil((_) => count++ >= 2);

                  Navigator.popUntil(context,
                      ModalRoute.withName(RouteConstant.sellCategoryPicker));
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: LocaleUtil.get('View this ad'),
                buttonTypeEnum: ButtonTypeEnum.origin,
                onPressed: () {
                  // ToastUtil.error('not done yet');
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyAds()),
                  //   ModalRoute.withName('/home/home_bottom_navigation'),
                  // );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           HomeBottomNavigation.fromAdSubmit()),
                  //   (Route<dynamic> route) => false,
                  // );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteConstant.myads, (route) => route.isFirst);
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: LocaleUtil.get('Close'),
                buttonTypeEnum: ButtonTypeEnum.origin,
                onPressed: () {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => HomeBottomNavigation()),
                  //   (Route<dynamic> route) => false,
                  // );

                  // Navigator.popUntil(context,
                  //     ModalRoute.withName(RouteConstant.homeBottomNavigation));

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ]),
          )),
    );
  }
}
