// import 'package:flutter/material.dart';
// import 'package:tolymoly/pages/buy/buy_ad_list.dart';
// import 'package:tolymoly/pages/buy/buy_search.dart';
// import 'package:tolymoly/pages/home/home_language.dart';
// import 'package:tolymoly/utils/color_util.dart';

// class Home extends StatefulWidget {
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Tolymoly'),
//           backgroundColor: ColorUtil.primary,
//           actions: <Widget>[
//             FlatButton(
//               child: Icon(
//                 Icons.search,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BuySearch.fromHome()),
//                 );
//               },
//             ),
//             FlatButton(
//               child: Icon(
//                 Icons.language,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeLanguage()),
//                 );
//               },
//             )
//           ],
//         ),
//         body: BuyAdList.fromHome());
//   }
// }
