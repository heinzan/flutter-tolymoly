import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/api/ad_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/buy_filter_dto.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/dto/location_picker_dto.dart';
import 'package:tolymoly/enum/price_type_enum.dart';
import 'package:tolymoly/enum/sort_enum.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';
import 'package:tolymoly/pages/buy/buy_filter.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/location_picker.dart';

class ComparePrice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ComparePriceState();
  }
}

class ComparePriceState extends State<ComparePrice> {
  int categoryId = 142;
  int pageNumber = 1;
  final String locationFilterLabel = LocaleUtil.get('Location');
  final String categoryFilterLabel = LocaleUtil.get('Category');
  final String filterFilterLabel = LocaleUtil.get('Filter');
  String locationFilterName;
  String categoryFilterName;
  String filterFilterName;
  String query;
  List compareList = new List();
  bool isLoading = false;
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
  bool hasMoreData = false;

  int lakhNumber = 100000;

  UserPreferenceService userPreferenceService = new UserPreferenceService();
  BuyFilterDto buyFilterDto = new BuyFilterDto();
  Color filterColor = Colors.black;
  Color locationColor = Colors.black;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    pageNumber = 1;
    locationFilterName = locationFilterLabel;
    categoryFilterName = categoryFilterLabel;
    filterFilterName = filterFilterLabel;

    _scrollController.addListener(() {
      //to check scroll position end and call api for pagination
      if (_scrollController.position.pixels !=
          _scrollController.position.maxScrollExtent) return;

      this.pageNumber += 1;
      hasMoreData ? _compareList() : ToastUtil.noMoreData();
    });

    _compareList();
  }

  _compareList() async {
    query = 'categoryId=$categoryId&pageNumber=$pageNumber';

    String sortQuery;

    _setLocation(UserPreferenceUtil.regionId, UserPreferenceUtil.regionName,
        UserPreferenceUtil.townshipId, UserPreferenceUtil.townshipName);

    if (regionIdQuery != null) query = query + '&regionId=$regionIdQuery';
    if (townshipIdQuery != null) query = query + '&townshipId=$townshipIdQuery';

    if (sortIdQuery != null) {
      if (sortIdQuery == SortEnum.NewestFirst.index) {
      } else if (sortIdQuery == SortEnum.PriceHighToLow.index) {
        sortQuery = '&sorting=sortingPrice.desc';
      } else if (sortIdQuery == SortEnum.PriceLowToHigh.index) {
        sortQuery = '&sorting=sortingPrice.asc';
      }
    }

    if (sortQuery != null) {
      query = query + sortQuery;
    }

    if (conditionIdQuery != null)
      query = query + '&conditionId=$conditionIdQuery';

    if (priceFromQuery != null) query = query + '&minPrice=$priceFromQuery';

    if (priceFromQuery != null) query = query + '&maxPrice=$priceToQuery';

    var res = await AdApi.getCompare(query);
    if (res.statusCode != 200) return;

    List tempList = new List();
    var jsonData = res.data;

    hasMoreData = jsonData.length > 0 ? true : false;

    for (int i = 0; i < jsonData.length; i++) {
      tempList.add(jsonData[i]);
    }
    compareList.addAll(tempList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Price'),
        backgroundColor: ColorConstant.primary,
      ),
      body: isLoading
          ? Center(child: new CircularProgressIndicator())
          : new RefreshIndicator(
              onRefresh: () => _reset(),
              child: Column(
                children: <Widget>[
                  _buildFilterBar(),
                  Expanded(
                    child: _list(),
                  )
                ],
              )),
    ); //);
  }

  Widget _buildFilterBar() {
    return Row(children: <Widget>[
      Expanded(
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
              style: TextStyle(color: locationColor)),
          //trailing: Icon(Icons.arrow_drop_down),
        ),
      ),
      Expanded(
        child: ListTile(
          onTap: () {
            showToast("Category");
          },
          title: Text(categoryFilterName, overflow: TextOverflow.ellipsis),
          //trailing: Icon(Icons.arrow_drop_down),
        ),
      ),
      Expanded(
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
          //trailing: Icon(Icons.arrow_drop_down),
        ),
      )
    ]);
  }

  Widget _list() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: compareList.length, //
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(compareList[index]['title'],
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                ],
              ),
              compareList[index]['newPrice'] != null
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: <Widget>[
                              Text('New: ',
                                  style: TextStyle(color: Colors.red)),
                              Text(getPrice(compareList[index]['newPrice']),
                                  style: TextStyle(color: Colors.red)),
                              Text(
                                  getPriceType(compareList[index]['priceType']),
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: ButtonTheme(
                              minWidth: 50.0,
                              height: 30.0,
                              child: OutlineButton(
                                child: Text('Buy'),
                                borderSide: BorderSide(color: Colors.blue),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BuyAdList.fromCompareNew(
                                              compareList[index]['id'])),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              width: 0,
                              height: 0,
                            ))
                      ],
                    )
                  : Container(width: 0, height: 0),
              compareList[index]['oldPrice'] != null
                  ? Row(children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Text('Old: ', style: TextStyle(color: Colors.blue)),
                            Text(getPrice(compareList[index]['oldPrice']),
                                style: TextStyle(color: Colors.blue)),
                            Text(getPriceType(compareList[index]['priceType']),
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      Expanded(
                          //margin: EdgeInsets.only(left: 50.0),
                          flex: 1,
                          child: ButtonTheme(
                            minWidth: 50.0,
                            height: 30.0,
                            child: OutlineButton(
                              child: Text('Buy'),
                              borderSide: BorderSide(color: Colors.blue),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BuyAdList.fromCompareOld(
                                            compareList[index]['id'])),
                              ),
                            ),
                          )),
                      Expanded(
                        child: Container(
                          width: 0,
                          height: 0,
                        ),
                        flex: 2,
                      )
                    ])
                  : Container(width: 0, height: 0),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                child: Divider(
                  color: Colors.black26,
                  height: 0.5,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String getPrice(price) {
    final formatter = new NumberFormat('#,###');
    String priceStr = formatter.format(price);
    return priceStr;
  }

  String getPriceType(type) {
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

  onTapLocation(LocationPickerDto dto) async {
    await userPreferenceService.updateBuyLocation(dto);
    _reset();
  }

  _setLocation(
      int regionId, String regionName, int townshipId, String townshipName) {
    bool hasSelection = false;
    if (regionId == 0) {
      locationFilterName = locationFilterLabel;
      regionIdQuery = null;
      townshipIdQuery = null;
    } else if (townshipId == 0) {
      locationFilterName = regionName;
      regionIdQuery = regionId;
      townshipIdQuery = null;
      hasSelection = true;
    } else {
      locationFilterName = townshipName;
      regionIdQuery = null;
      townshipIdQuery = townshipId;
      hasSelection = true;
    }
    locationColor = hasSelection ? Colors.orange : Colors.black;
  }

  onTapCategory(CategoryPickerDto dto) {
    _setCategoryQuery(dto);
    //_reset();
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
      if (dto.id == 0) {
        categoryFilterName = categoryFilterLabel;
      } else {
        categoryIdLevel1Query = dto.categoryIdLevel1;
      }
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
    filterColor = hasSelection ? Colors.orange : Colors.black;

    _reset();
  }

  Future<Null> _reset() async {
    this.compareList.clear();
    this.pageNumber = 1;
    this.hasMoreData = false;
    await _compareList();
  }
}
