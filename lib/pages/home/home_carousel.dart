// import 'package:flutter/material.dart';
// import 'package:tolymoly/constants/asset_path_constant.dart';
// import 'package:tolymoly/pages/buy/buy_ad_list.dart';
// import 'package:tolymoly/utils/locale/locale_util.dart';

// class HomeCarousel extends StatefulWidget {
//   _HomeCarouselState createState() => _HomeCarouselState();
// }

// class _HomeCarouselState extends State<HomeCarousel> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => BuyAdList.fromBuy()),
//           );
//         },
//         child: Container(
//           constraints: BoxConstraints.expand(height: 220.0),
//           alignment: Alignment.topLeft,
//           padding: EdgeInsets.only(left: 20.0, top: 20.0),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage(AssetPathConstant.homeBanner)),
//           ),
//           child: Column(
//             children: <Widget>[
//               _buildText(LocaleUtil.get('Anyone can')),
//               _buildText(LocaleUtil.get('buy and sell'))
//             ],
//           ),
//         )
//         // child: Stack(children: <Widget>[
//         //   Image.asset('assets/images/home_banner.png'),
//         //   Center(child: Text("someText")),
//         // ])
//         // child: Container(
//         //   child: Image.asset('assets/images/home_banner.png'),
//         // ),
//         );
//   }

//   Widget _buildText(String text) {
//     return Text(text,
//         style: new TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22.0,
//             height: 1.6,
//             color: Colors.grey[800]));
//   }
// }
