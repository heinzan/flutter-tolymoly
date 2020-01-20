import 'package:flutter/material.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/seller_profile_dto.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class BuySellerProfile extends StatefulWidget {
  final SellerProfileDto sellerProfileDto;

  BuySellerProfile.buy(this.sellerProfileDto);
  // BuySellerProfile.me();
  _BuySellerProfileState createState() => _BuySellerProfileState();
}

class _BuySellerProfileState extends State<BuySellerProfile> {
  // bool isDataLoaded = false;
  int minDescriptionLines = 3;
  int maxDescriptionLines = 200;

  @override
  void initState() {
    print('===============');
    print('user profile > initState');
    print('===============');
    _getData();
    super.initState();
  }

  void _getData() async {
    // Response response = await UserApi.getSellerProfile(widget.userId);
    // sellerProfileDto = SellerProfileDto.fromMap(response.data);
    // isDataLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.sellerProfileDto.image),
            ),
            SizedBox(height: 10),
            Text(widget.sellerProfileDto.username),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(LocaleUtil.get('Confirmed'),
                    style: TextStyle(color: Colors.blueGrey)),
                SizedBox(
                  width: 3,
                ),
                if (![null, '']
                    .contains(widget.sellerProfileDto.isRegisteredByFacebook))
                  Image.asset(AssetPathConstant.facebook),
                if (![null, '']
                    .contains(widget.sellerProfileDto.isRegisteredBySms))
                  Icon(
                    Icons.phone_android,
                    color: Colors.grey,
                    size: 25.0,
                  ),
              ],
            ),
            Text(
                '${LocaleUtil.get('Joined')} ${widget.sellerProfileDto.joinedDate}',
                style: TextStyle(color: Colors.blueGrey)),
            SizedBox(height: 10),
            _buildDescription()
          ],
        ));
  }

  Widget _buildDescription() {
    if (widget.sellerProfileDto.description == null) return SizedBox.shrink();

    return Column(children: <Widget>[
      Text(
        widget.sellerProfileDto.description,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: minDescriptionLines,
      ),
      minDescriptionLines == maxDescriptionLines
          ? SizedBox.shrink()
          : FlatButton(
              child: Text(LocaleUtil.get(LabelConstant.more),
                  style: TextStyle(color: ColorConstant.link)),
              onPressed: () =>
                  setState(() => minDescriptionLines = maxDescriptionLines))
    ]);
  }
}
