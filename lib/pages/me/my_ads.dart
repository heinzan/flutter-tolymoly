import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/my_ads_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/enum/ad_status_enum.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class MyAds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAdsState();
  }
}

class MyAdsState extends State<MyAds> with TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: LocaleUtil.get('Active'),
    ),
    Tab(text: LocaleUtil.get('Inactive')),
    Tab(text: LocaleUtil.get('Sold')),
  ];

  String activeStatus = '1,7,8,9,10';
  String inactiveStatus = '6,2,5';
  String soldStatus = '3';
  int pageNumber = 1;
  int pageSize = 10;
  bool isFinished = false;
  bool isLoading = false;
  bool isScrolled = false;
  bool isRefresh = false;
  List activeAdsList = new List();
  List inactiveAdsList = new List();
  List soldAdsList = new List();

  TabController _tabController;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      initialIndex: 0,
      vsync: this,
      length: myTabs.length,
    );

    _tabController.animation.addListener(() {
      if (_tabController.indexIsChanging) this._tabControllerListener();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels !=
              _scrollController.position.maxScrollExtent ||
          isFinished) return;

      this.pageNumber += 1;
      this.callGetMyAdsList(_tabController.index);
      this.isScrolled = true;
    });

    getMyAdsList(AdStatusEnum.active, activeStatus);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _tabControllerListener() {
    int index = _tabController.index;
    this.pageNumber = 1;
    isFinished = false;
    this.activeAdsList = [];
    this.inactiveAdsList = [];
    this.soldAdsList = [];
    callGetMyAdsList(index);
  }

  void callGetMyAdsList(index) {
    switch (index) {
      case 0:
        getMyAdsList(AdStatusEnum.active, activeStatus);
        break;
      case 1:
        getMyAdsList(AdStatusEnum.inactive, inactiveStatus);
        break;
      case 2:
        getMyAdsList(AdStatusEnum.sold, soldStatus);
        break;
    }
  }

  void getMyAdsList(status, statusNo) async {
    if (isLoading) return;

    isLoading = true;
    setState(() {});

    var res = await MyAdsApi.getMyAds(statusNo, this.pageNumber);

    if (res.statusCode != 200) return;

    List tempList = new List();
    var jsonData = res.data;
    jsonData.length < 1 || jsonData.length % pageSize != 0
        ? isFinished = true
        : isFinished = false; //stop or call paging api call
    for (int i = 0; i < jsonData.length; i++) {
      tempList.add(jsonData[i]);
    }

    isLoading = false;
    isScrolled = false;
    isRefresh = false;
    switch (status) {
      case AdStatusEnum.active:
        pageNumber > 1
            ? this.activeAdsList.addAll(tempList)
            : this.activeAdsList = tempList;
        break;
      case AdStatusEnum.inactive:
        pageNumber > 1
            ? this.inactiveAdsList.addAll(tempList)
            : this.inactiveAdsList = tempList;
        break;
      case AdStatusEnum.sold:
        pageNumber > 1
            ? this.soldAdsList.addAll(tempList)
            : this.soldAdsList = tempList;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('My Ads')),
        backgroundColor: ColorConstant.primary,
        automaticallyImplyLeading: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: isLoading && !isScrolled && !isRefresh
          ? Center(child: CircularProgressIndicator())
          : TabBarView(controller: _tabController, children: <Widget>[
              list(this.activeAdsList),
              list(this.inactiveAdsList),
              list(this.soldAdsList)
            ]),
    );
  }

  Widget list(List tabList) {
    return new RefreshIndicator(
      onRefresh: _handleRefresh,
      child: createListView(tabList),
    );
  }

  Widget createListView(tabList) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tabList.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.all(10.0),
            child: new InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return BuyAdDetail(tabList[index]['id']);
                }));
              },
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: <Widget>[
                            tabList[index]['myAdCoverImage'] != null
                                ? Image.network(
                                    tabList[index]['myAdCoverImage'])
                                : Image.asset('assets/images/default_image.jpg',
                                    height: 50.0),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(tabList[index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Container(
                                    child: Text(
                                        getDate(tabList[index]['createdDate']),
                                        style:
                                            Theme.of(context).textTheme.body1),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Container(
                                    child: getTextOfStatus(
                                        tabList[index]['status']),
                                    alignment: Alignment.topLeft,
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      Column(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(getPrice(tabList[index]['price'])),
                            Text(getPriceType(tabList[index]['priceType'])),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.favorite),
                            Text(getCount(tabList[index]['favouriteCount'])),
                            Icon(Icons.visibility),
                            Text(getCount(tabList[index]['viewCount'])),
                          ],
                        ),
                      ]),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ));
      },
      controller: _scrollController,
    );
  }

  Future<Null> _handleRefresh() async {
    var logger = new Logger();
    logger.d('Enter Refresh');
    isRefresh = true;
    await _tabControllerListener();
    return null;
  }

  String getDate(date) {
    return DateFormat.yMd().format(DateTime.parse(date));
  }

  String getPrice(adsPrice) {
    if (adsPrice == null) return '';
    final formatter = new NumberFormat('#,###');
    String price = formatter.format(adsPrice);
    return price;
  }

  String getPriceType(type) {
    if (type == null) return '';
    String priceType;
    switch (type) {
      case 1:
        priceType = ' Ks';
        break;
      case 2:
        priceType = ' Lks';
        break;
      case 3:
        priceType = ' USD';
        break;
      default:
        priceType = ' Ks';
        break;
    }
    return priceType;
  }

  String getCount(count) {
    if (count == null) {
      return '0 ';
    } else {
      return count.toString() + ' ';
    }
  }

  Widget getTextOfStatus(status) {
    String sts = '';
    Color color;
    switch (status) {
      case 2:
        sts = LocaleUtil.get('Draft');
        color = Colors.blue;
        break;
      case 5:
        sts = LocaleUtil.get('Rejected');
        color = Colors.red;
        break;
      case 7:
        sts = LocaleUtil.get('Pending verification');
        color = Colors.orange[800];
        break;
      case 8:
        sts = LocaleUtil.get('Reported');
        color = Colors.orange[800];
        break;
      case 9:
        sts = LocaleUtil.get('Pending verification');
        color = Colors.orange[800];
        break;
      case 10:
        sts = LocaleUtil.get('Pending verification');
        color = Colors.orange[800];

        break;
    }
    Widget statusText = Text(
      sts,
      style: TextStyle(color: color),
    );
    return statusText;
  }
}
