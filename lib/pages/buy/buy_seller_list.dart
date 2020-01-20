import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/enum/search_type_enum.dart';
import 'package:tolymoly/services/user_search_service.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class BuySellerList extends StatefulWidget {
  _BuySellerListState createState() => _BuySellerListState();
}

class _BuySellerListState extends State<BuySellerList> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0.0,
            title: _buildSearchTitle(),
            backgroundColor: ColorConstant.primary),
        body: _buildList());
  }

  Widget _buildList() {
    return ListView.builder(
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            // title: Text(userSearchModels[index].name),
            title: Text('1'),
            onTap: () {});
      },
    );
  }

  Widget _buildSearchTitle() {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Container(
                // padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Expanded(
                    child: TextField(
              autofocus: true,
              controller: searchController,
              // textInputAction: TextInputAction.go,
              // style: new TextStyle(
              //   color: Colors.white,

              // ),
              style: BurmeseUtil.textStyle(context),
              decoration: new InputDecoration(
                  // border: InputBorder.none,
                  contentPadding: EdgeInsets.all(5.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      // borderSide: BorderSide(color: Colors.white, width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)),
                  prefixIcon: new Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: UserPreferenceUtil.keyboardTypeEnum ==
                          KeyboardTypeEnum.Zawgyi
                      ? BurmeseUtil.toZawgyi(
                          LocaleUtil.get(LabelConstant.searchHint))
                      : LocaleUtil.get(LabelConstant.searchHint),
                  hintStyle: new TextStyle(color: Colors.black54)),
            ))),
            // FlatButton(
            //   // padding: EdgeInsets.all(0),
            //   onPressed: () async {
            //     String name = searchController.text;
            //     await _save(name);
            //     await _search(name);
            //   },
            //   child: Text('Search', style: TextStyle(color: Colors.white)),
            //   // color: Colors.grey,
            //   // child: Icon(
            //   //   Icons.search,
            //   //   color: ColorConstant.appBarIcon,
            //   // )
            // )
            SizedBox(width: 8),
            InkWell(
                onTap: () async {
                  String name = searchController.text;
                  await _save(name);
                  await _search(name);
                },
                child: Text(LocaleUtil.get(LabelConstant.search))),
            SizedBox(width: 8),
          ],
        ));
  }

  Future<void> _save(String text) async {
    String searchText = text.trim();
    if (searchText.isNotEmpty) {
      await UserSearchService.save(searchText, SearchTypeEnum.User);
    }
  }

  Future<void> _search(String text) async {}
}
