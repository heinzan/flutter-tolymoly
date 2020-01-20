import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/ad_api.dart';
import 'package:tolymoly/api/ad_category_api.dart';
import 'package:tolymoly/api/user_api.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/buy_filter_dto.dart';
import 'package:tolymoly/dto/buy_search_dto.dart';
import 'package:tolymoly/dto/category_dto.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/dto/horizontal_ad_dto.dart';
import 'package:tolymoly/dto/location_picker_dto.dart';
import 'package:tolymoly/dto/seller_profile_dto.dart';
import 'package:tolymoly/enum/condition_enum.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/price_type_enum.dart';
import 'package:tolymoly/enum/sort_enum.dart';
import 'package:tolymoly/models/ad_list_model.dart';
import 'package:tolymoly/models/category_model.dart';
import 'package:tolymoly/pages/auth/auth_tab.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/pages/buy/buy_ad_list_row.dart';
import 'package:tolymoly/pages/buy/buy_report.dart';
import 'package:tolymoly/pages/buy/buy_category_picker.dart';
import 'package:tolymoly/pages/buy/buy_filter.dart';
import 'package:tolymoly/pages/buy/buy_search.dart';
import 'package:tolymoly/pages/buy/buy_seller_profile.dart';
import 'package:tolymoly/pages/home/home_carousel.dart';
import 'package:tolymoly/pages/home/home_compare_phone.dart';
import 'package:tolymoly/pages/home/home_header.dart';
import 'package:tolymoly/pages/home/home_language.dart';
import 'package:tolymoly/repositories/category_repository.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/price_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/location_picker.dart';

class BuyAdList extends StatefulWidget {
  bool showHomeAppBar = false;
  bool showSeachAppBar = false;
  bool showCarousel = false;
  bool showComparePhone = false;
  bool showFilterBar = false;
  bool showCategory = false;
  bool showSellerProfile = false;
  bool showSellerAppBar = false;
  bool showHorizontalAd = false;
  bool showIndexAds = false;
  bool isFromSearchBar = false;
  CategoryPickerDto categoryPickerDto;

  // BuySearchDto buySearchDto;
  // BuySearchDto buySearchDto;
  int userId;
  int mobileModelId;
  int conditionId;
  SortEnum compareSort;
  String searchTextEntered = '';

  BuyAdList.fromBuy()
      : this.showSeachAppBar = true,
        this.showFilterBar = true;

  // this.showCarousel = false,
  // this.showComparePhone = false,
  // this.showCategory = false,
  // this.categoryPickerDto = null,
  // this.buySearchDto = null;

  BuyAdList.fromCompareNew(this.mobileModelId)
      : this.showSeachAppBar = true,
        this.showFilterBar = true,
        this.compareSort = SortEnum.PriceLowToHigh,
        this.conditionId = ConditionEnum.New.index;

  BuyAdList.fromCompareOld(this.mobileModelId)
      : this.showSeachAppBar = true,
        this.showFilterBar = true,
        this.compareSort = SortEnum.PriceLowToHigh,
        this.conditionId = ConditionEnum.Used.index;

  BuyAdList.fromCategory(this.categoryPickerDto)
      : this.showSeachAppBar = true,
        this.showFilterBar = true;

  // this.showCarousel = false,
  // this.showComparePhone = false,
  // this.showCategory = false,
  // this.buySearchDto = null;

  // BuyAdList.fromSubCategory(this.categoryPickerDto, this.subCategoryLevel)
  //     : this.showSeachAppBar = true,
  //       this.showFilterBar = true;

  BuyAdList.fromHome()
      : this.showCarousel = true,
        this.showComparePhone = true,
        this.showCategory = true,
        this.showHorizontalAd = true,
        this.showHomeAppBar = true,
        this.showIndexAds = true;

  // this.showSeachAppBar = false,
  // this.showFilterBar = false,
  // this.categoryPickerDto = null,
  // this.buySearchDto = null;

  BuyAdList.fromSearchBar(this.searchTextEntered)
      : this.showSeachAppBar = true,
        this.showFilterBar = true,
        this.isFromSearchBar = true;

  // this.showCarousel = false,
  // this.showComparePhone = false,
  // this.showCategory = false,
  // this.categoryPickerDto = null;

  BuyAdList.fromSellerProfile(this.userId)
      : showSellerAppBar = true,
        showSellerProfile = true;

  @override
  _BuyAdListState createState() => _BuyAdListState();
}

class _BuyAdListState extends State<BuyAdList> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     new GlobalKey<RefreshIndicatorState>();
  Logger logger = new Logger();
  final formatter = new NumberFormat("#,###");
  double fontname = 16.0;
  double fontTitle = 16.0;
  double fontPrice = 16.0;

  Color borderColor = Colors.grey[200];
  Color usernameColor = Colors.black;
  Color titleColor = Colors.black;
  Color priceColor = Colors.orange[800];

  ScrollController _scrollController = new ScrollController();

  // bool isLoading = false;

  int pageNumber = 1;
  int lakhNumber = 100000;

  List<AdListModel> ads = new List<AdListModel>();
  List<HorizontalAdDto> newPhoneAds = new List<HorizontalAdDto>();
  List<HorizontalAdDto> usedPhoneAds = new List<HorizontalAdDto>();
  List<HorizontalAdDto> propertyForSaleAds = new List<HorizontalAdDto>();
  List<HorizontalAdDto> propertyForRentAds = new List<HorizontalAdDto>();
  List<HorizontalAdDto> carAds = new List<HorizontalAdDto>();

  final String locationFilterLabel = LocaleUtil.get('Location');
  final String categoryFilterLabel = LocaleUtil.get('Category');
  final String filterFilterLabel = LocaleUtil.get('Filter');
  String locationFilterName;
  String categoryFilterName;
  String filterFilterName;

  int categoryIdLevel1Query;
  int categoryIdLevel2Query;
  int categoryIdLevel3Query;
  int regionIdQuery;
  int townshipIdQuery;
  int sortIdQuery;
  int conditionIdQuery;
  int priceTypeQuery;
  int priceFromQuery;
  int priceToQuery;
  int mobileModelIdQuery;
  String searchQuery;

  bool hasMoreData = false;
  List<CategoryModel> categories = new List<CategoryModel>();
  BuyFilterDto buyFilterDto = new BuyFilterDto();
  Color filterColor = Colors.black;
  UserPreferenceService userPreferenceService = new UserPreferenceService();
  List<CategoryModel> subCategories;
  StreamController<bool> refreshStreamController =
      new StreamController.broadcast();
  SellerProfileDto sellerProfileDto;
  bool isDataLoaded = false;
  String searchTextEntered = '';

  // IndexedStack indexedStackNewPhone;
  // HomeNewPhone homeNewPhone;

  @override
  void initState() {
    print('buy ad list > initState');
    // ads.add(null); // carousel
    // ads.add(null); // comapare phone
    if (widget.isFromSearchBar) searchTextEntered = widget.searchTextEntered;
    if (widget.mobileModelId != null) mobileModelIdQuery = widget.mobileModelId;
    if (widget.compareSort != null) sortIdQuery = widget.compareSort.index;
    if (widget.conditionId != null) conditionIdQuery = widget.conditionId;

    locationFilterName = locationFilterLabel;
    categoryFilterName = categoryFilterLabel;
    filterFilterName = filterFilterLabel;

    if (widget.categoryPickerDto != null) {
      _setCategoryQuery(widget.categoryPickerDto);
    }

    // _setSearchQuery(widget.buySearchDto);

    // this._getData(pageNumber);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // pageNumber = pageNumber + 1;
        // hasMoreData ? _getData(pageNumber) : ToastUtil.noMoreData();

        if (hasMoreData) {
          pageNumber = pageNumber + 1;
          // _getData();
          _getMoreAdData();
        } else {
          ToastUtil.noMoreData();
        }
      }
    });

    _reset();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _reset() {
    print('buy ad list > _reset...');

    pageNumber = 1;

    ads.clear();

    categories.clear();

    newPhoneAds.clear();
    usedPhoneAds.clear();
    propertyForRentAds.clear();
    propertyForSaleAds.clear();
    carAds.clear();

    /* 
     always add 2  null for top widget
     one can do, but the next fist ad will always show loading which is not pretty
    */
    ads.add(null);
    ads.add(null);

    _getData();
  }

  void _getData() async {
    // if (isLoading) return;

    // isLoading = true;

    if (widget.showCategory) await _getCategoryData();

    if (widget.showFilterBar && widget.categoryPickerDto != null)
      await _getSubCategoryData();

    if (widget.showSellerProfile) await _getSellerProfileData();

    if (widget.showSeachAppBar) _setSearchQuery(searchTextEntered);

    // if (widget.showHorizontalAd)
    //   indexedStackNewPhone =
    //       IndexedStack(index: 0, children: <Widget>[HomeNewPhone()]);

    if (widget.showHorizontalAd) await _getHorizontalAdData();

    _setLocation(UserPreferenceUtil.regionId, UserPreferenceUtil.regionName,
        UserPreferenceUtil.townshipId, UserPreferenceUtil.townshipName);

    await _getAdData();

    // isLoading = false;
    isDataLoaded = true;
    setState(() {});
  }

  Future<void> _getCategoryData() async {
    Response response = await AdCategoryApi.get();

    // List<int> ids = List<int>();
    // for (int i = 0; i < response.data.length; i++) {
    //   CategoryDto dto = CategoryDto.fromMap(response.data[i]);
    //   ids.add(dto.id);
    // }
    // List<int> ids = response.data;
    await CategoryRepository.updateHasQuantity(response.data);
    // categories = await CategoryRepository.findHasQuantity(1, 0);
    categories = await CategoryRepository.findHasQuantity(0);
  }

  Future<void> _getSubCategoryData() async {
    // print(widget.categoryPickerDto.id);
    subCategories =
        await CategoryRepository.findHasQuantity(widget.categoryPickerDto.id);
  }

  Future<void> _getSellerProfileData() async {
    Response response = await UserApi.getSellerProfile(widget.userId);
    sellerProfileDto = SellerProfileDto.fromMap(response.data);
  }

  Future<void> _getAdData() async {
    var response;
    if (widget.showIndexAds) {
      response = await AdApi.getIndex(pageNumber);
    } else if (widget.showSellerProfile) {
      response = await AdApi.getSellerAds(widget.userId, pageNumber);
    } else {
      response = await AdApi.get(createQuery());
    }
    hasMoreData = response.data.length > 0 ? true : false;

    for (int i = 0; i < response.data.length; i++) {
      ads.add(AdListModel.fromMap(response.data[i]));
    }
  }

  void _getMoreAdData() async {
    await _getAdData();
    setState(() {});
  }

  Future<void> _getHorizontalAdData() async {
    var response = await AdApi.getIndexAdList();

    for (int i = 0; i < response.data['newPhones'].length; i++) {
      newPhoneAds.add(HorizontalAdDto.fromMap(response.data['newPhones'][i]));
    }
    for (int i = 0; i < response.data['usedPhones'].length; i++) {
      usedPhoneAds.add(HorizontalAdDto.fromMap(response.data['usedPhones'][i]));
    }
    for (int i = 0; i < response.data['propertiesForRent'].length; i++) {
      propertyForRentAds
          .add(HorizontalAdDto.fromMap(response.data['propertiesForRent'][i]));
    }
    for (int i = 0; i < response.data['propertiesForSale'].length; i++) {
      propertyForSaleAds
          .add(HorizontalAdDto.fromMap(response.data['propertiesForSale'][i]));
    }
    for (int i = 0; i < response.data['cars'].length; i++) {
      carAds.add(HorizontalAdDto.fromMap(response.data['cars'][i]));
    }

    // newPhoneAds = response.data['newPhones'];
    // usedPhoneAds = response.data['usedPhones'];
    // propertyForRentAds = response.data['propertiesForRent'];
    // propertyForSaleAds = response.data['propertiesForSale'];
    // carAds = response.data['cars'];
  }

  String createQuery() {
    String query = 'pageNumber=$pageNumber';

    if (regionIdQuery != null) query = query + '&regionId=$regionIdQuery';
    if (townshipIdQuery != null) query = query + '&townshipId=$townshipIdQuery';

    if (categoryIdLevel1Query != null)
      query = query + '&categoryIdLevel1=$categoryIdLevel1Query';

    if (categoryIdLevel2Query != null)
      query = query + '&categoryIdLevel2=$categoryIdLevel2Query';

    if (categoryIdLevel3Query != null)
      query = query + '&categoryIdLevel3=$categoryIdLevel3Query';

    if (priceFromQuery != null) query = query + '&minPrice=$priceFromQuery';
    if (priceToQuery != null) query = query + '&maxPrice=$priceToQuery';

    if (mobileModelIdQuery != null)
      query = query + '&mobileModelId=$mobileModelIdQuery';

    String sortQuery;
    if (sortIdQuery == null) {
      // sortQuery =
      //     'createdDate.desc'; // do nothing, because this is backend default
    } else {
      if (sortIdQuery == SortEnum.NewestFirst.index) {
        // sortQuery =
        //     'createdDate.desc'; // do nothing, because this is backend default
      } else if (sortIdQuery == SortEnum.PriceHighToLow.index) {
        sortQuery = 'sortingPrice.desc';
      } else if (sortIdQuery == SortEnum.PriceLowToHigh.index) {
        sortQuery = 'sortingPrice.asc';
      }
    }
    if (sortQuery != null) query = query + '&sorting=$sortQuery';

    if (conditionIdQuery != null)
      query = query + '&conditionId=$conditionIdQuery';

    if (searchQuery != null) query = query + '&searchKey=$searchQuery';

    return query;
  }

  @override
  Widget build(BuildContext context) {
    print('buy ad list > build...');
    return isDataLoaded
        ? Scaffold(
            appBar: _buildAppBar(),
            body: RefreshIndicator(
              child: Column(
                children: <Widget>[
                  if (widget.showFilterBar) _buildFilterBar(),
                  Expanded(
                    child: _buildList(),
                  )
                ],
              ),
              onRefresh: _pullToRefresh,
            ),
            // resizeToAvoidBottomInset: false,
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  AppBar _buildAppBar() {
    print('_buildAppBar...');

    if (widget.showHomeAppBar) {
      return AppBar(
        title: Text('Tolymoly'),
        // titleSpacing: 0.0,
        backgroundColor: ColorConstant.primary,
        actions: <Widget>[
          _buildSearchTextfield(190, LocaleUtil.get(LabelConstant.searchHint),
              BuySearch.fromHome()),
          IconButton(
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeLanguage()),
              );
            },
          )
        ],
      );
    } else if (widget.showSeachAppBar) {
      return AppBar(
        title: _buildSearchTextfieldFromAd(double.infinity, searchTextEntered),
        backgroundColor: ColorConstant.primary,
      );
    } else if (widget.showSellerAppBar) {
      return AppBar(
          title: Text(LocaleUtil.get('Seller Profile')),
          backgroundColor: ColorConstant.primary,
          actions: [
            PopupMenuButton(
              offset: Offset(0, 50),
              onSelected: (result) {
                bool isAtuh = _validateAuth();
                if (!isAtuh) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BuyReport.fromUser(widget.userId)));
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                    value: true,
                    child: Text(LocaleUtil.get(LabelConstant.reportUser))),
              ],
            )
          ]);
    } else {
      return null;
    }
  }

  Widget _buildSearchTextfield(double width, String text, var to) {
    return Container(
        width: width,
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: FlatButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => to));
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 5),
                Text(text, style: TextStyle(color: Colors.black54))
              ],
            ),
            color: Colors.white,
            // borderSide: new BorderSide(color: Colors.white),
            shape: StadiumBorder()));
  }

  Widget _buildSearchTextfieldFromAd(double width, String text) {
    return Container(
        width: width,
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: FlatButton(
            onPressed: () async {
              String searchText = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          new BuySearch.fromAd(searchTextEntered)));
              if (searchText != null) {
                searchTextEntered = searchText;
                _reset();
              }
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 5),
                Text(text, style: TextStyle(color: Colors.black54))
              ],
            ),
            color: Colors.white,
            // borderSide: new BorderSide(color: Colors.white),
            shape: StadiumBorder()));
  }

  Future<Null> _pullToRefresh() async {
    _reset();
    // refreshStreamController.add(true);

    return null;
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: ads.length, // + 1,
      itemBuilder: (BuildContext context, int index) {
        // if (index == ads.length) {
        if (index == 0) return _buildTopWidget();

        if (index == 1) return SizedBox.shrink(); // do nothing

        if (index.isOdd) return SizedBox.shrink(); // do nothing

        if (index < ads.length - 1) {
          return BuyAdListRow(ads[index], ads[index + 1]);
        }

        return BuyAdListRow(ads[index], null);
      },
      controller: _scrollController,
    );
  }

  Widget _buildTopWidget() {
    return Column(children: <Widget>[
      if (widget.showCarousel) _buildCarousel(),

      if (widget.showCarousel)
        HomeHeader.withMore(LocaleUtil.get('Categories'),
            LocaleUtil.get('See all >'), BuyAdList.fromBuy()),

      if (widget.showCategory)
        // HomeCategory(categories), // child will not rebuild
        _buildCategory(),

      if (widget.showComparePhone)
        HomeComparePhone(),

      if (widget.showHorizontalAd)
        _buildHorizontalAd(),

      if (widget.showSellerProfile)
        BuySellerProfile.buy(sellerProfileDto),

      if (widget.showComparePhone)
        HomeHeader(LocaleUtil.get('Explore')),
      // if (widget.showFilterBar) _buildFilterBar(),
    ]);
  }

  Widget _buildCarousel() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuyAdList.fromBuy()),
          );
        },
        child: Container(
          constraints: BoxConstraints.expand(height: 220.0),
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPathConstant.homeBanner)),
          ),
          child: Column(
            children: <Widget>[
              _buildCarouselText(LocaleUtil.get('Anyone can')),
              _buildCarouselText(LocaleUtil.get('buy and sell'))
            ],
          ),
        )
        // child: Stack(children: <Widget>[
        //   Image.asset('assets/images/home_banner.png'),
        //   Center(child: Text("someText")),
        // ])
        // child: Container(
        //   child: Image.asset('assets/images/home_banner.png'),
        // ),
        );
  }

  Widget _buildCarouselText(String text) {
    return Text(text,
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            height: 1.6,
            color: Colors.grey[800]));
  }

  Widget _buildHorizontalAd() {
    List<Widget> list = List();
    CategoryPickerDto newPhoneDto = new CategoryPickerDto();
    newPhoneDto.id = 142;
    newPhoneDto.name = 'Mobile Phones';
    newPhoneDto.categoryIdLevel1 = 141;
    newPhoneDto.categoryIdLevel2 = 142;

    CategoryPickerDto usedPhoneDto = new CategoryPickerDto();
    usedPhoneDto.id = 142;
    usedPhoneDto.name = 'Mobile Phones';
    usedPhoneDto.categoryIdLevel1 = 141;
    usedPhoneDto.categoryIdLevel2 = 142;

    CategoryPickerDto propertyForSaleDto = new CategoryPickerDto();
    propertyForSaleDto.id = 373;
    propertyForSaleDto.name = 'For sale';
    propertyForSaleDto.categoryIdLevel1 = 371;
    propertyForSaleDto.categoryIdLevel2 = 373;

    CategoryPickerDto propertyForRentDto = new CategoryPickerDto();
    propertyForRentDto.id = 372;
    propertyForRentDto.name = 'For rent';
    propertyForRentDto.categoryIdLevel1 = 371;
    propertyForRentDto.categoryIdLevel2 = 372;

    CategoryPickerDto carDto = new CategoryPickerDto();
    carDto.id = 226;
    carDto.name = 'Mobile Phones';
    carDto.categoryIdLevel1 = 226;

    list.add(HomeHeader.withMore(LocaleUtil.get(LabelConstant.newPhones),
        LocaleUtil.get('See all >'), BuyAdList.fromCategory(newPhoneDto)));
    list.add(_buildHorizontalAdList(newPhoneAds, newPhoneDto));

    // list.add(HomeHeader.withMore(
    //     LocaleUtil.get(LabelConstant.usedPhones), LocaleUtil.get('See all >')));
    // list.add(_buildHorizontalAdList(usedPhoneAds, usedPhoneDto));

    list.add(HomeHeader.withMore(
        LocaleUtil.get(LabelConstant.propertyForRent),
        LocaleUtil.get('See all >'),
        BuyAdList.fromCategory(propertyForRentDto)));
    list.add(_buildHorizontalAdList(propertyForRentAds, propertyForRentDto));

    list.add(HomeHeader.withMore(
        LocaleUtil.get(LabelConstant.propertyForSale),
        LocaleUtil.get('See all >'),
        BuyAdList.fromCategory(propertyForSaleDto)));
    list.add(_buildHorizontalAdList(propertyForSaleAds, propertyForSaleDto));

    list.add(HomeHeader.withMore(LocaleUtil.get(LabelConstant.cars),
        LocaleUtil.get('See all >'), BuyAdList.fromCategory(carDto)));
    list.add(_buildHorizontalAdList(carAds, carDto));

    return Column(children: list);
  }

  Widget _buildHorizontalAdList(
      List<HorizontalAdDto> list, CategoryPickerDto dto) {
    double imageHeight = 90;

    return Container(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length + 1,
          itemBuilder: (BuildContext context, int index) {
            var coverImage;
            Widget price;
            Widget widget;
            if (index < list.length) {
              coverImage = list[index].image == null
                  ? Image.asset(AssetPathConstant.defaultImage,
                      height: imageHeight)
                  : CachedNetworkImage(
                      imageUrl: list[index].image, height: imageHeight);

              price = Text(
                  PriceUtil.price(list[index].price, list[index].priceType),
                  overflow: TextOverflow.ellipsis);

              widget = BuyAdDetail(list[index].id);
            } else {
              coverImage = Container(
                  width: 80,
                  child: Icon(Icons.play_arrow, size: 40, color: Colors.grey));
              price = Text('More', style: TextStyle(color: Colors.black54));
              widget = BuyAdList.fromCategory(dto);
            }

            return Padding(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => widget),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[coverImage, price])));
          },
        ));
  }

  Widget _buildCategory() {
    double height = UserPreferenceUtil.displayLanguageTypeEnum ==
            DisplayLanguageTypeEnum.Burmese
        ? 240
        : 176;
    List<Widget> icons = new List<Widget>();

    icons.add(SizedBox(width: 10));

    for (int i = 0; i < categories.length; i++) {
      if (i.isOdd) continue;

      if (i < categories.length - 1) {
        icons.add(Column(
          children: <Widget>[
            _buildCatgoryItem(height / 2, categories[i]),
            _buildCatgoryItem(height / 2, categories[i + 1])
          ],
        ));
      } else {
        icons.add(Column(
          children: <Widget>[_buildCatgoryItem(height / 2, categories[i])],
        ));
      }
    }

    return Container(
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: icons,
      ),
    );
  }

  Widget _buildCatgoryItem(double height, CategoryModel category) {
    CategoryPickerDto dto = CategoryPickerDto.fromCategoryModel(category);

    String iconPath = category.name;
    iconPath = iconPath.replaceAll('&', 'and');
    iconPath = iconPath.replaceAll(' ', '_');
    iconPath = iconPath.replaceAll("`", '');
    iconPath = iconPath.replaceAll("'", '');

    // print(iconPath);

    String name = UserPreferenceUtil.displayLanguageTypeEnum ==
            DisplayLanguageTypeEnum.English
        ? category.name
        : category.mmUnicode;

    // name = name.substring(0, 20);
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BuyAdList.fromCategory(dto)),
          );
        },
        child: Container(
            width: 100,
            height: height,
            child: Column(
              children: <Widget>[
                Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange),
                        image: new DecorationImage(
                            // fit: BoxFit.fill,

                            image: new AssetImage(
                                AssetPathConstant.category(iconPath))))),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            )));
  }

  Widget _buildFilterBar() {
    int categoryId;
    if (widget.categoryPickerDto == null) {
      categoryId = null;
    } else {
      categoryId = widget.categoryPickerDto.id;
    }
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new LocationPicker.filter(onTapLocation)));
              },
              title: Text(locationFilterName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: locationFilterName == locationFilterLabel
                          ? Colors.black
                          : ColorConstant.primary)),
              // trailing: Icon(Icons.arrow_drop_down),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new BuyCategoryPicker(onTapCategory, categoryId)));
              },
              title: Text(categoryFilterName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: categoryFilterName == categoryFilterLabel
                          ? Colors.black
                          : ColorConstant.primary)),
              // trailing: Icon(Icons.arrow_drop_down),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new BuyFilter(onTapFilter, buyFilterDto)));
              },
              title: Text(filterFilterName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: filterColor)),
              // trailing: Icon(Icons.arrow_drop_down),
            ),
          )
        ]),
        Container(
          height: subCategories == null || subCategories.length == 0 ? 0 : 40,
          child: ListView(
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.horizontal,
            children: _buildSubCategory(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSubCategory() {
    List<Widget> list = new List();

    if (subCategories == null || subCategories.length == 0) {
      list.add(SizedBox.shrink());
      return list;
    }

    for (int i = 0; i < subCategories.length; i++) {
      String name;
      if (UserPreferenceUtil.displayLanguageTypeEnum ==
          DisplayLanguageTypeEnum.English) {
        name = subCategories[i].name;
      } else {
        name = subCategories[i].mmUnicode;
      }

      list.add(OutlineButton(
        onPressed: () {
          CategoryPickerDto dto =
              CategoryPickerDto.fromCategoryModel(subCategories[i]);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BuyAdList.fromCategory(dto)),
          );
        },
        shape: StadiumBorder(),
        borderSide: BorderSide(color: ColorConstant.link),
        child: Text(name, style: TextStyle(color: ColorConstant.link)),
      ));

      list.add(SizedBox(width: 3));
    }

    return list;
  }

  onTapLocation(LocationPickerDto dto) async {
    await userPreferenceService.updateBuyLocation(dto);

    // _setLocation(
    //     dto.regionId, dto.regionName, dto.townshipId, dto.townshipName);
    _reset();
  }

  _setLocation(
      int regionId, String regionName, int townshipId, String townshipName) {
    if (regionId == 0) {
      locationFilterName = locationFilterLabel;
      regionIdQuery = null;
      townshipIdQuery = null;
    } else if (townshipId == 0) {
      locationFilterName = regionName;
      regionIdQuery = regionId;
      townshipIdQuery = null;
    } else {
      locationFilterName = townshipName;
      regionIdQuery = null;
      townshipIdQuery = townshipId;
    }
  }

  onTapCategory(CategoryPickerDto dto) {
    _setCategoryQuery(dto);
    widget.categoryPickerDto = dto; // to remember the category filter
    _reset();
  }

  _setCategoryQuery(CategoryPickerDto dto) {
    categoryIdLevel1Query = null;
    categoryIdLevel2Query = null;
    categoryIdLevel3Query = null;

    if (dto.categoryIdLevel3 != null) {
      categoryIdLevel3Query = dto.categoryIdLevel3;
      categoryFilterName = dto.name;
    } else if (dto.categoryIdLevel2 != null) {
      categoryIdLevel2Query = dto.categoryIdLevel2;
      categoryFilterName = dto.name;
    } else if (dto.categoryIdLevel1 != null) {
      categoryIdLevel1Query = dto.categoryIdLevel1;
      categoryFilterName = dto.name;

      // if (dto.id == 0) {
      //   categoryFilterName = categoryFilterLabel;
      // } else {
      //   categoryIdLevel1Query = dto.categoryIdLevel1;
      //   categoryFilterName = dto.name;
      // }
    } else {
      categoryFilterName = categoryFilterLabel;
    }
  }

  onTapFilter(BuyFilterDto dto) {
    bool hasSelection = false;
    if (dto.sortId == null || dto.sortId == 0) {
      sortIdQuery = null;
    } else {
      sortIdQuery = dto.sortId;
      hasSelection = true;
    }

    if (dto.conditionId == null || dto.conditionId == 0) {
      conditionIdQuery = null;
    } else {
      conditionIdQuery = dto.conditionId;
      hasSelection = true;
    }

    if (dto.priceFrom == null || dto.priceFrom == 0) {
      priceFromQuery = null;
    } else {
      if (dto.priceTypeId == PriceTypeEnum.Lakh.index) {
        priceFromQuery = dto.priceFrom * lakhNumber;
      } else {
        priceFromQuery = dto.priceFrom;
      }
    }

    if (dto.priceTo == null || dto.priceTo == 0) {
      priceToQuery = null;
    } else {
      if (dto.priceTypeId == PriceTypeEnum.Lakh.index) {
        priceToQuery = dto.priceTo * lakhNumber;
      } else {
        priceToQuery = dto.priceTo;
      }
      hasSelection = true;
    }

    this.buyFilterDto = dto;
    filterColor = hasSelection ? ColorConstant.primary : Colors.black;

    _reset();
  }

  // onTapSearch(BuySearchDto dto) {
  //   _setSearchQuery(dto);
  //   _reset();
  // }

  // _setSearchQuery(BuySearchDto dto) {
  //   if (dto == null || dto.textEntered == null || dto.textEntered.isEmpty) {
  //     searchQuery = null;
  //     searchTextEntered = '';
  //   } else {
  //     searchQuery = dto.textEntered;
  //     searchTextEntered = dto.textEntered;

  //     print('=====');
  //     print(searchTextEntered);
  //     print('=====');
  //   }
  // }

  // onTapSearch(String searchTextEntered) {
  //   // _setSearchQuery(searchTextEntered);
  //   widget.searchTextEntered = searchTextEntered;
  //   print('onTapSearch=====');
  //   print(widget.searchTextEntered);
  //   print('onTapSearch=====');

  //   _reset();
  // }

  _setSearchQuery(String searchTextEntered) {
    if (searchTextEntered == null || searchTextEntered.isEmpty) {
      searchQuery = null;
    } else {
      searchQuery = searchTextEntered;
    }
  }

  bool _validateAuth() {
    if (!AuthUtil.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthTab()),
      );
      return false;
    }
    return true;
  }
}
