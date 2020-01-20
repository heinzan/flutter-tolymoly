import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/api/my_favourite_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/price_util.dart';
import 'package:tolymoly/utils/toast_util.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  Map<String, bool> checkboxValue = new Map();
  List deleteAdIdList = new List();
  List favAdsList = new List();
  var logger = new Logger();

  int pageNumber = 1;
  int pageSize = 10;

  bool isLoading = false;
  bool isDeleteMode = false;
  bool isFinished = true;

  ScrollController _scrollController = new ScrollController();

  double screenWidth;
  double screenHeight;

  @override
  void initState() {
    _getFavouriteAdsList();
    _scrollController.addListener(() {
      //to check scroll position end and call api for pagination
      if (_scrollController.position.pixels !=
              _scrollController.position.maxScrollExtent ||
          isFinished) return;

      this.pageNumber += 1;
      _getFavouriteAdsList();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getFavouriteAdsList() async {
    isLoading = true;
    var res = await MyFavouriteApi.get(this.pageNumber);
    logger.d(res);
    if (res.statusCode != 200) {
      isLoading = false;
      return;
    }

    List tempList = new List();
    var jsonData = res.data;
    jsonData.length < 1 || jsonData.length % pageSize != 0
        ? isFinished = true
        : isFinished = false; //stop or call paging api call
    for (int i = 0; i < jsonData.length; i++) {
      tempList.add(jsonData[i]);
      int id = jsonData[i]['id'];
      checkboxValue['id$id'] =
          false; //control checkbox value with their id keys
    }
    logger.d(checkboxValue);

    this.favAdsList += tempList;
    setState(() {});
    isLoading = false;

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    logger.d('ScreenWidth: $screenWidth');
    logger.d('screenHeight: $screenHeight');

    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
  }

  void _deleteFavouritAds() async {
    if (this.deleteAdIdList.length < 1) {
      showToast(LocaleUtil.get('No selected data'),
          backgroundColor: Colors.redAccent[400]);
      return;
    }

    Map data = {'adIds': this.deleteAdIdList};
    var res = await MyFavouriteApi.delete(data);
    logger.d(res.statusCode);
    if (res.statusCode != 200) return;
    //after delete fav ads, set the default state

    ToastUtil.success();
    this.deleteAdIdList = [];
    this.pageNumber = 1;
    this.favAdsList = [];
    this.isDeleteMode = false;
    _getFavouriteAdsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Favourites')),
        backgroundColor: ColorConstant.primary,
        actions: <Widget>[
          isDeleteMode
              ? FlatButton(
                  textColor: Colors.white,
                  child: Text(LocaleUtil.get('Delete')),
                  onPressed: () => _deleteFavouritAds(),
                )
              : Text(''),
          GestureDetector(
            onTap: () {
              this.isDeleteMode = !this.isDeleteMode;

              if (this.isDeleteMode) return setState(() {});

              this.deleteAdIdList = [];
              this.checkboxValue.forEach((key, value) {
                //If delete Icon clicked from deletemode, set false to all checkbox value.
                if (value) this.checkboxValue[key] = false;
              });
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.delete,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: new CircularProgressIndicator())
          : new RefreshIndicator(onRefresh: _refresh, child: _gridList()),
    );
  }

  Widget _gridList() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: favAdsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, //ratio of Grid Item width and height
      ),
      itemBuilder: (context, index) {
        return Container(
            child: new InkWell(
                onTap: () {
                  !isDeleteMode
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                          return BuyAdDetail(favAdsList[index]['id']);
                        }))
                      : changeCheckValue(favAdsList[index]['id']);
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GridTile(
                        header: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SizedBox(
                              child: GridTileBar(
                                backgroundColor:
                                    isDeleteMode ? Colors.black38 : null,
                                leading: isDeleteMode
                                    ? Checkbox(
                                        activeColor: Colors.lightGreen[500],
                                        value: getCheckValue(
                                            favAdsList[index]['id']),
                                        onChanged: (bool) {
                                          changeCheckValue(
                                              favAdsList[index]['id']);
                                        })
                                    : null,
                                title: Text(' '),
                                trailing: Icon(
                                  Icons.favorite,
                                  color: Colors.red[800],
                                ),
                              ),
                            )),
                        child: Card(
                            child: Column(
                          children: <Widget>[
                            favAdsList[index]['coverImage'] != null
                                ? Image.network(
                                    favAdsList[index]['coverImage'],
                                    width: (this.screenWidth - 10.0) / 2,
                                    height: (this.screenWidth - 10.0) / 2,
                                  )
                                : Image.asset(
                                    'assets/images/default_image.jpg'),
                            Container(
                              margin: EdgeInsets.all(4.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(favAdsList[index]['title'],
                                        style: TextStyle(
                                          fontSize: 11.5, height: 1.3
                                        ),
                                        overflow: TextOverflow.ellipsis),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(PriceUtil.price(
                                            favAdsList[index]['price'],
                                            favAdsList[index]['priceType']))
                                      ],
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                  ],
                )));
      },
      controller: _scrollController,
    );
  }

  Future<Null> _refresh() async {
    //before refresh api call, set default value state
    this.pageNumber = 1;
    isFinished = false;
    this.favAdsList = [];
    await _getFavouriteAdsList();
  }

  void changeCheckValue(id) {
    logger.d('ID:$id');
    this.checkboxValue['id$id'] = !this.checkboxValue['id$id'];
    //if the value is true, add to list. if value is false, remove from list.
    this.checkboxValue['id$id']
        ? deleteAdIdList.add(id)
        : deleteAdIdList.remove(id);
    setState(() {});
  }

  bool getCheckValue(id) {
    return this.checkboxValue['id$id'];
  }
}
