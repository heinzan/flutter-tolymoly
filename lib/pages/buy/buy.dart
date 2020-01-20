// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:tolymoly/dto/buy_search_dto.dart';
// import 'package:tolymoly/pages/buy/buy_ad_list.dart';
// import 'package:tolymoly/pages/buy/buy_search.dart';

// class Buy extends StatefulWidget {
//   _BuyState createState() => _BuyState();
// }

// class _BuyState extends State<Buy> {
//   Logger logger = new Logger();
//   BuySearchDto buySearchDto = new BuySearchDto();
//   String searchTextEntered = '';

//   @override
//   Widget build(BuildContext context) {
//     logger.d('=====1');
//     logger.d(buySearchDto.textEntered);
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           // controller: searchController,
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         BuySearch(onTapSearch, searchTextEntered)));
//           },
//           style: new TextStyle(
//             color: Colors.white,
//           ),
//           decoration: new InputDecoration(
//               border: InputBorder.none,
//               prefixIcon: new Icon(Icons.search, color: Colors.white),
//               hintText:
//                   searchTextEntered.isEmpty ? 'Search...' : searchTextEntered,
//               hintStyle: new TextStyle(color: Colors.white)),
//         ),
//       ),
//       body: BuyAdList.buy(buySearchDto),
//     );
//   }

//   onTapSearch(BuySearchDto dto) {
//     searchTextEntered = dto.textEntered;
//     buySearchDto = dto;
//     setState(() {});
//   }
// }
