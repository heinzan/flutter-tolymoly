import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/models/ad_list_model.dart';
import 'package:tolymoly/pages/buy/buy_ad_detail.dart';
import 'package:tolymoly/utils/price_util.dart';

class BuyAdListRow extends StatelessWidget {
  final AdListModel adListModel;
  final AdListModel adListModel2;
  BuyAdListRow(this.adListModel, this.adListModel2);
  double itemWidth = 0;
  double nameWidth = 0;
  // double paddingSize = 4;
  // double paddingSize = 0;
  double avatarSize = 30;
  double nameLeftMargin = 4;
  double horizontalSpaceBetweenAd = 5;
  double adImageWidth = 0;
  double adImageHeight = 0;
  double rowBottomPadding = 5;
  double rowSidePadding = 5;
  double itemInnerPadding = 5;
  double titleWidth = 0;
  double priceFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: rowBottomPadding,
            left: rowSidePadding,
            right: rowSidePadding),
        child: Row(
          children: <Widget>[
            _buildItem(context, adListModel),
            SizedBox(
              width: 5,
            ),
            adListModel2 == null
                ? SizedBox.shrink()
                : _buildItem(context, adListModel2),

            // _buildItem(index + 1)
          ],
        ));
  }

  Widget _buildItem(BuildContext context, AdListModel adListModel) {
    var coverImage = [null, ''].contains(adListModel.coverImage)
        ? AssetImage(AssetPathConstant.defaultImage)
        : NetworkImage(adListModel.coverImage);

    var userImage = [null, ''].contains(adListModel.userImage)
        ? SizedBox
            .shrink() //Icon(Icons.person, size: avatarSize, color: Colors.grey)
        : CircleAvatar(
            maxRadius: avatarSize / 2,
            backgroundImage: CachedNetworkImageProvider(adListModel.userImage));

    itemWidth = (MediaQuery.of(context).size.width -
            horizontalSpaceBetweenAd -
            rowSidePadding * 2) /
        2;

    adImageWidth = itemWidth;
    adImageHeight = itemWidth;

    // titleWidth = itemWidth - itemInnerPadding * 2;

    nameWidth =
        itemWidth - itemInnerPadding * 2 - avatarSize - nameLeftMargin - 2;
    return Container(
        padding:
            EdgeInsets.only(top: itemInnerPadding, bottom: itemInnerPadding),
        constraints: BoxConstraints(maxWidth: itemWidth),
        // padding: EdgeInsets.all(paddingSize),
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey[200]),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new BuyAdDetail(adListModel.id)));
            // builder: (context) => new AdDetailTest()));
          },
          // child: Card(
          // clipBehavior: Clip.antiAlias,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text('id: ' + adListModel.id.toString()),

              Padding(
                  padding: EdgeInsets.only(
                      left: itemInnerPadding, right: itemInnerPadding),
                  child: Row(
                    children: <Widget>[
                      userImage,
                      SizedBox(
                        width: nameLeftMargin,
                      ),
                      Container(
                          constraints: BoxConstraints(maxWidth: nameWidth),
                          child: Text(
                            adListModel.username == null
                                ? ''
                                : adListModel.username,
                            // adListModel.id.toString(),
                            // itemWidth.toString(),
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 1,
                          )),
                    ],
                  )),
              // Image(
              //     image: new CachedNetworkImageProvider(adListModel.coverImage)),
              SizedBox(
                height: 2,
              ),
              Container(
                width: adImageWidth,
                height: adImageHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: coverImage,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: itemInnerPadding, right: itemInnerPadding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(adListModel.title,
                              overflow: TextOverflow.ellipsis),
                          // Text(index.toString()),
                          SizedBox(height: 8.0),
                          Text(
                              PriceUtil.price(
                                  adListModel.price, adListModel.priceType),
                              style: TextStyle(
                                  fontSize: priceFontSize,
                                  color: ColorConstant.price),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  )),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Text(adListModel.title),
              //     SizedBox(height: 8.0),
              //     Text(adListModel.price.toString()),
              //   ],
              // ),
            ],
          ),
          // )
        ));
  }
}
