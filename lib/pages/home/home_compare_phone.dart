import 'package:flutter/material.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/pages/home/home_header.dart';
import 'package:tolymoly/pages/home/compare_price.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class HomeComparePhone extends StatefulWidget {
  _HomeComparePhoneState createState() => _HomeComparePhoneState();
}

class _HomeComparePhoneState extends State<HomeComparePhone> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HomeHeader(LocaleUtil.get('Compare phones')),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ComparePrice()),
            );
          },
          child: Container(
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            height: 150,
            child: Image.asset(AssetPathConstant.comparePhone),
          ),
        )
      ],
    );
  }
}
