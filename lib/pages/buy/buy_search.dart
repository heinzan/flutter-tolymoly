import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/dto/buy_search_dto.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/enum/search_type_enum.dart';
import 'package:tolymoly/models/user_search_model.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';
import 'package:tolymoly/repositories/user_search_repository.dart';
import 'package:tolymoly/services/user_search_service.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class BuySearch extends StatefulWidget {
  // final Function onTapSearch;
  String textEntered;
  bool fromHome = false;
  bool showSearchUser = false;
  bool showHistory = false;
  bool isSearchUser = false;

  BuySearch.fromAd(this.textEntered);
  BuySearch.fromSearchUser() : isSearchUser = true;
  // BuySearch.fromHome()
  //     : this.onTapSearch = null,
  //       this.textEntered = null;
  BuySearch.fromHome()
      : this.fromHome = true,
        this.showSearchUser = false,
        this.showHistory = true;

  _BuySearchState createState() => _BuySearchState();
}

class _BuySearchState extends State<BuySearch> {
  final searchController = TextEditingController();
  List<UserSearchModel> userSearchModels;
  bool isDataLoaded = false;
  bool toDelete = false;

  @override
  void initState() {
    searchController.text = widget.textEntered;
    _getData();
    super.initState();
  }

  void _getData() async {
    userSearchModels = await UserSearchRepository.find();

    isDataLoaded = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          title: _buildSearchTitle(),
          backgroundColor: ColorConstant.primary),
      body: isDataLoaded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.showSearchUser)
                  ListTile(
                    title: Text(LocaleUtil.get(LabelConstant.searchUser),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuySearch.fromSearchUser()),
                      );
                    },
                  ),
                if (widget.showHistory)
                  ListTile(
                    title: Text(LocaleUtil.get(LabelConstant.searchHistory),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.delete),
                    onTap: () {
                      toDelete = !toDelete;
                      setState(() {});
                    },
                  ),
                if (widget.showHistory)
                  Expanded(
                    child: ListView.builder(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: userSearchModels.length,
                      itemBuilder: (BuildContext context, int index) {
                        String name = userSearchModels[index].text;
                        return ListTile(
                            // title: Text(userSearchModels[index].name),
                            title: Text(name),
                            onTap: () {
                              _search(name);
                            },
                            trailing: toDelete
                                ? InkWell(
                                    onTap: () async {
                                      bool isSuccss =
                                          await UserSearchService.delete(
                                              name, SearchTypeEnum.Ad);
                                      if (isSuccss) _getData();
                                    },
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ))
                                : SizedBox.shrink());
                      },
                    ),
                  ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
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
                  hintStyle: TextStyle(color: Colors.black54)),
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
                child: Text(LocaleUtil.get(LabelConstant.search),
                    style: TextStyle(fontSize: 16))),
            SizedBox(width: 8),
          ],
        ));
  }

  Future<void> _save(String text) async {
    String searchText = text.trim();
    if (searchText.isNotEmpty) {
      await UserSearchService.save(searchText, SearchTypeEnum.Ad);
    }
  }

  Future<void> _search(String text) async {
    if (widget.fromHome) {
      Navigator.popAndPushNamed(context, RouteConstant.buyAdListFromSearchBar,
          arguments: text);
    } else if (widget.isSearchUser) {
    } else {
      Navigator.pop(context, text);
    }
  }
}
