import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/ad_api.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/dto/chat_detail_dto.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/enum/price_type_enum.dart';
import 'package:tolymoly/models/ad_detail_model.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:tolymoly/models/category_model.dart';
import 'package:tolymoly/pages/auth/auth_tab.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail_bottom.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tolymoly/pages/buy/buy_ad_list.dart';
import 'package:tolymoly/pages/buy/buy_report.dart';
import 'package:tolymoly/pages/buy/buy_image.dart';
import 'package:tolymoly/pages/sell/sell_form.dart';
import 'package:tolymoly/repositories/category_repository.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/price_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class BuyAdDetail extends StatefulWidget {
  final int adId;
  BuyAdDetail(this.adId);

  _BuyAdDetailState createState() => _BuyAdDetailState();
}

class _BuyAdDetailState extends State<BuyAdDetail> {
  Logger logger = new Logger();

  AdDetailModel adDetailModel;
  List<Image> images = new List<Image>();
  bool isDataLoaded = false;
  // Map<String, AttributeModel> attributeMap = new Map<String, AttributeModel>();
  double fontSize16 = 16.0;
  double fontSize20 = 20.0;
  // bool isOwner = false;
  // int userId = 0;
  Map data = new Map();
  String titleValue;
  String priceValue;
  String salaryValue;
  // String priceTypeValue;
  int priceTypeInt;

  String regionValue;
  String townshipValue;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    print('_getData');

    // List<AttributeModel> attributeList = await AttributeRepository.find();

    // for (var i = 0; i < attributeList.length; i++) {
    //   attributeMap[attributeList[i].name] = attributeList[i];
    // }

    var response = await AdApi.getShow(
        widget.adId, UserPreferenceUtil.displayLanguageTypeEnum.index);

    logger.d(response.data);

    adDetailModel = AdDetailModel.fromMap(response.data);
    // List<AttributeDto2> dtos = adDetailModel.attributes;
    for (int i = 0; i < response.data['attributes'].length; i++) {
      String label = response.data['attributes'][i]['label'];
      String name = response.data['attributes'][i]['name'];
      String value = response.data['attributes'][i]['value'];

      print('$name: $value');

      if (value == null) continue;

      switch (name) {
        case 'title':
          titleValue = value;
          break;
        case 'price':
          priceValue = value;
          break;
        case 'salary':
          salaryValue = value;
          break;
        case 'priceType':
          switch (value) {
            case 'Kyat':
              priceTypeInt = PriceTypeEnum.Kyat.index;
              break;
            case 'Lakh':
              priceTypeInt = PriceTypeEnum.Lakh.index;
              break;
            case 'USD':
              priceTypeInt = PriceTypeEnum.Usd.index;
              break;
          }
          break;
        case 'regionId':
          regionValue = value;
          break;
        case 'townshipId':
          townshipValue = value;
          break;
        default:
          data[label] = value;
      }
    }

    if (salaryValue != null && salaryValue.isNotEmpty) priceValue = salaryValue;

    _setImage();

    isDataLoaded = true;

    setState(() {});
  }

  void _setImage() {
    for (var i = 0; i < adDetailModel.image.length; i++) {
      images.add(Image(
          image:
              new CachedNetworkImageProvider(adDetailModel.image[i].imageUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      // body: isDataLoaded ? _buildDetail(context) : SizedBox.shrink(),
      body: Stack(
        children: <Widget>[
          isDataLoaded ? _buildDetail(context) : SizedBox.shrink(),
          new Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildAppBar(),
          ),
        ],
      ),
      bottomNavigationBar: isDataLoaded
          ? _buildBottomChatBar()
          : Center(child: CircularProgressIndicator()),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, //No more green
      elevation: 0.0, //Shadow
      leading: Padding(
          padding: EdgeInsets.only(left: 0, top: 0),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            color: Colors.black26,
          )),
      // centerTitle: true,
      // leading: IconButton(
      //   icon: Icon(
      //     Icons.chevron_left,
      //     size: 40.0,
      //     color: Colors.black,
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      // ),
      // title: Text(
      //   "Ad: ${widget.adId}",
      //   style: TextStyle(
      //     color: Colors.black,
      //   ),
      // ),
    );
  }

  Widget _buildBottomChatBar() {
    ChatDetailDto chatDetailDto = new ChatDetailDto();
    chatDetailDto.adId = adDetailModel.id;
    chatDetailDto.adTitle = titleValue;
    chatDetailDto.adImage = adDetailModel.image[0].imageUrl;
    chatDetailDto.receiverId = adDetailModel.sellerInfo.id;
    chatDetailDto.receiverName = adDetailModel.sellerInfo.name;
    chatDetailDto.receiverImage = adDetailModel.sellerInfo.image;
    chatDetailDto.adPrice = double.parse(priceValue);
    chatDetailDto.adPriceType = priceTypeInt;

    return adDetailModel.sellerInfo.id == AuthUtil.userId
        ? SizedBox.shrink()
        : BuyAdDetailBottom(
            chatDetailDto,
            adDetailModel.isFavourite,
            adDetailModel.id,
            adDetailModel.sellerInfo.phone,
            adDetailModel.sellerInfo.facebookMessenger);
  }

  _buildDetail(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildImage(),
              SizedBox(height: 12.0),

              _buildTitle(),
              SizedBox(height: 12.0),

              _buildPrice(),
              SizedBox(height: 12.0),

              _buildCategory(LocaleUtil.get('Category')),
              SizedBox(height: 12.0),

              _buildAttribute(),
              SizedBox(height: 12.0),

              _buildTitleBar(LocaleUtil.get('Location')),
              SizedBox(height: 12.0),

              _buildLocation(regionValue, townshipValue),
              SizedBox(height: 12.0),

              _buildTitleBar(LocaleUtil.get('Seller')),
              SizedBox(height: 12.0),

              _buildSeller(),
              SizedBox(height: 12.0),

              _buildAdId(),
              SizedBox(height: 12.0),

              // _buildTitleBar(LocaleUtil.get('You may also like')),
              // SizedBox(height: 12.0),

              if (adDetailModel.sellerInfo.id == AuthUtil.userId)
                _buildOwner(),

              SizedBox(height: 20.0),

              // _buildAttribute(_getLabelName('condition'), _getReferenceName('condition', adDetailModel.conditionId)),
            ],
          ),
        ),
      ],
    );
  }
//  String _getLabelName(String attributeName) {
//     return attributeMap[attributeName].labelName;
//   }

//   Future<String> _getReferenceName(String tableName,int referenceId) async {
//     return await ReferenceRepository.findName(tableName, referenceId);
//   }

  _buildImage() {
    return SizedBox(
        height: 450.0,
        child: Carousel(
          onImageTap: (index) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyImage(
                    adImageModels: adDetailModel.image,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    initialIndex: index,
                  ),
                ));
          },
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Colors.black,
          indicatorBgPadding: 1.0,
          // dotBgColor: Colors.purple.withOpacity(0.5),
          autoplay: false,
          dotBgColor: Colors.grey[50].withOpacity(0.5),
          // overlayShadow: false,
          // showIndicator: false,
          images: images,
        ));
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Text(
        titleValue,
        style: TextStyle(fontSize: fontSize20, color: Colors.black),
      ),
    );
  }

  _buildPrice() {
    double priceDouble = double.parse(priceValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            // 'Ks ' + formatter.format(adDetailModel.price),
            // 'Ks ${adDetailModel.price.toString()}',
            // '$priceTypeValue ${PriceUtil.value(priceDouble)}',
            '${PriceUtil.price(priceDouble, priceTypeInt)}',
            style: TextStyle(fontSize: fontSize20, color: ColorConstant.price),
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            timeago.format(DateTime.parse(adDetailModel.createdDate)),
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  _buildCategory(String label) {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < adDetailModel.category.length; i++) {
      String categoryName = adDetailModel.category[i].name;
      int categoryId = adDetailModel.category[i].id;

      list.add(
        InkWell(
          onTap: () async {
            CategoryPickerDto dto = new CategoryPickerDto();
            CategoryModel model = await CategoryRepository.findById(categoryId);
            dto.id = model.id;
            dto.name = model.name;
            dto.mmUnicode = model.mmUnicode;
            dto.categoryIdLevel1 = model.categoryIdLevel1;
            dto.categoryIdLevel2 = model.categoryIdLevel2;
            dto.categoryIdLevel3 = model.categoryIdLevel3;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyAdList.fromCategory(dto)),
            );
          },
          child: Text(
            '$categoryName >',
            style: TextStyle(fontSize: fontSize16, color: Colors.blue),
          ),
        ),
      );

      list.add(SizedBox(
        height: 10,
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize16, color: Colors.blueGrey),
            )),
        Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            )),
      ],
    );
  }

  Widget _buildAttribute() {
    List<Widget> list = List();

    data.forEach((key, value) {
      list.add(_buildAttributeRow(key, value));
      list.add(SizedBox(
        height: 10,
      ));
    });

    return Column(
      children: list,
    );
  }

  Widget _buildAttributeRow(String label, String text) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize16, color: Colors.blueGrey),
            )),
        Expanded(
            flex: 7,
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize16),
            )),
      ],
    );
  }

  _buildTitleBar(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Text(name, style: TextStyle(fontSize: fontSize20)),
    );
  }

  _buildLocation(String region, String tonwship) {
    return Text(
      '$region-$tonwship',
      style: TextStyle(fontSize: fontSize16),
    );
  }

  _buildOwner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity,
        child: CustomButton(
          onPressed: () {
            // var data = {
            //   'categoryId': adDetailModel.categoryId,
            //   'adId': adDetailModel.id
            // };
            Navigator.push(
              context,
              MaterialPageRoute(
                  // builder: (context) => SellForm(adDetailModel.id, null)),
                  builder: (context) => SellForm.edit(adDetailModel.id)),
            );
          },
          text: LocaleUtil.get('Edit'),
          buttonTypeEnum: ButtonTypeEnum.origin,
        ),
      ),
    );
  }

  _buildSeller() {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BuyAdList.fromSellerProfile(adDetailModel.sellerInfo.id)),
        );
      },
      leading: adDetailModel.sellerInfo.image == null
          ? Icon(Icons.person, size: 50)
          : CircleAvatar(
              backgroundImage: NetworkImage(adDetailModel.sellerInfo.image),
            ),
      title: Text(adDetailModel.sellerInfo.name),
      // subtitle: Text('Confirmed', style: TextStyle(color: Colors.blueGrey)),
      subtitle: Row(
        children: <Widget>[
          Text(LocaleUtil.get('Confirmed'),
              style: TextStyle(color: Colors.blueGrey)),
          SizedBox(
            width: 3,
          ),
          if (adDetailModel.sellerInfo.isRegisteredByFacebook)
            Image.asset(AssetPathConstant.facebook),
          if (adDetailModel.sellerInfo.isRegisteredBySms)
            Icon(
              Icons.phone_android,
              color: Colors.grey,
              size: 30.0,
            ),
        ],
      ),
    );
  }

  _buildAdId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Ad ID: ${adDetailModel.id.toString()}',
          style: TextStyle(fontSize: fontSize16),
        ),
        InkWell(
          onTap: () {
            bool isAtuh = _validateAuth();
            if (!isAtuh) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyReport.fromDetail(adDetailModel.id)),
            );
          },
          child: Text(LocaleUtil.get('Report Ad'),
              style: TextStyle(fontSize: fontSize16, color: Colors.blue)),
        )
      ],
    );
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
