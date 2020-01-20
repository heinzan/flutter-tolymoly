// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:tolymoly/api/ad_api.dart';
// import 'package:tolymoly/constants/asset_path_constant.dart';
// import 'package:tolymoly/enum/condition_enum.dart';
// import 'package:tolymoly/models/ad_list_model.dart';
// import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
// import 'package:tolymoly/utils/price_util.dart';
// import 'package:tolymoly/utils/toast_util.dart';

// class HomeNewPhone extends StatefulWidget {
//   // final StreamController<bool> refreshStreamController;
//   // HomeNewPhone(this.refreshStreamController);
//   // HomeNewPhone();
//   final List<AdListModel> ads;
//   HomeNewPhone(this.ads);

//   _HomeNewPhoneState createState() => _HomeNewPhoneState();
// }

// class _HomeNewPhoneState extends State<HomeNewPhone> {
//   int pageNumber = 1;
//   List<AdListModel> ads = new List<AdListModel>();
//   double imageHeight = 80;
//   ScrollController _scrollController = new ScrollController();
//   bool hasMoreData = false;
//   StreamSubscription streamSubscription;
//   int categoryIdLevel2Query = 142;

//   @override
//   void initState() {
//     print('////////////////////////////');
//     print('new phone > initState ===========');
//     print('////////////////////////////');
//     ads = widget.ads;
//     print('ads.length: ${ads.length}');
//     // _getData();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         // _getData();
//         if (hasMoreData) {
//           pageNumber = pageNumber + 1;
//           _getData();
//         } else {
//           ToastUtil.noMoreData();
//         }
//       }
//     });

//     setState(() {});
//     // streamSubscription =
//     //     widget.refreshStreamController.stream.listen((message) {
//     //   // pageNumber = 0;
//     //   // ads.clear();
//     //   // _getData();
//     // });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     if (streamSubscription != null) streamSubscription.cancel();

//     super.dispose();
//   }

//   void _getData() async {
//     String query = 'pageNumber=$pageNumber';
//     query = query + '&conditionId=${ConditionEnum.New.index}';
//     query = query + '&categoryIdLevel2=$categoryIdLevel2Query';

//     var response = await AdApi.get(query);

//     hasMoreData = response.data.length > 0 ? true : false;

//     for (int i = 0; i < response.data.length; i++) {
//       ads.add(AdListModel.fromMap(response.data[i]));
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('=====================');
//     print('new phone > build=====================');
//     print('=====================');
//     print('ads.length: ${ads.length}');

//     return Container(
//         height: 120,
//         child: ListView.builder(
//           //+1 for progressbar
//           scrollDirection: Axis.horizontal,
//           itemCount: ads.length,
//           itemBuilder: (BuildContext context, int index) {
//             var coverImage = ads[index].coverImage == null
//                 ? Image.asset(AssetPathConstant.defaultImage,
//                     height: imageHeight)
//                 : CachedNetworkImage(
//                     imageUrl: ads[index].coverImage, height: imageHeight);
//             return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => BuyAdDetail(ads[index].id)),
//                   );
//                 },
//                 child: Column(children: <Widget>[
//                   coverImage,
//                   Text(PriceUtil.price(ads[index].price, ads[index].priceType))
//                 ]));
//           },
//           controller: _scrollController,
//         ));
//   }
// }
