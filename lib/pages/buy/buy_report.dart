import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tolymoly/api/ad_report_api.dart';
import 'package:tolymoly/api/user_report_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class BuyReport extends StatefulWidget {
  final int adId;
  final int userId;
  final String apiName;
  final String appbarLabel;

  //check page for ad report or user report
  BuyReport.fromDetail(this.adId)
      : this.userId = 0,
        this.apiName = 'adReport',
        this.appbarLabel = 'Report Ad';
  BuyReport.fromUser(this.userId)
      : this.adId = 0,
        this.apiName = 'userReport',
        this.appbarLabel = 'Report User';

  @override
  State<StatefulWidget> createState() {
    return BuyReportState();
  }
}

class BuyReportState extends State<BuyReport> {
  //checkbox values
  bool isWrongCategory = false;
  bool isWrongDesc = false;
  bool isWrongPicture = false;
  bool isWrongPrice = false;
  bool isDuplicate = false;
  bool isProhibited = false;
  bool isCounterfeit = false;
  bool isNoLongerAvailable = false;
  bool isUnresponsivePoster = false;
  bool isScam = false;

  TextEditingController reasonController = new TextEditingController();

  //calling report post api
  void _reportAds(String reasonText) async {
    String reason = reasonText.trim();

    //validate empty report
    if (!isWrongCategory &&
        !isWrongDesc &&
        !isWrongPicture &&
        !isWrongPrice &&
        !isDuplicate &&
        !isProhibited &&
        !isCounterfeit &&
        !isNoLongerAvailable &&
        !isUnresponsivePoster &&
        !isScam &&
        reason == "") {
      ToastUtil.error('No selected data');
      return;
    }

    Map data = {
      //'adId': widget.adId,
      'hasWrongCategory': isWrongCategory,
      'hasWrongDescription': isWrongDesc,
      'hasWrongPicture': isWrongPicture,
      'hasDifferentPrice': isWrongPrice,
      'hasDuplicateAd': isDuplicate,
      'hasProhibitedItem': isProhibited,
      'hasCounterfeitItem': isCounterfeit,
      'hasNoLongerAvailableItem': isNoLongerAvailable,
      'hasUnresponsivePoster': isUnresponsivePoster,
      'hasScam': isScam,
      'reason': BurmeseUtil.toUnicode(reason)
    };

    //check and change api
    var res;
    if (widget.apiName == 'adReport') {
      Map ad = {'adId': widget.adId};
      data.addAll(ad);
      res = await AdReportApi.post(data);
    } else {
      Map user = {'userId': widget.userId};
      data.addAll(user);
      res = await UserReportApi.post(data);
    }

    print(res.data);
    if (res.statusCode != 200) return;
    ToastUtil.success();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleUtil.get(widget.appbarLabel)),
          backgroundColor: ColorConstant.primary,
        ),
        body: SingleChildScrollView(
          child: _formList(),
        ));
  }

  Widget _formList() {
    return new Column(children: <Widget>[
      CheckboxListTile(
          title: Text(LocaleUtil.get('Wrong category')),
          value: isWrongCategory,
          onChanged: (bool) =>
              {isWrongCategory = !isWrongCategory, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Wrong description')),
          value: isWrongDesc,
          onChanged: (bool) => {isWrongDesc = !isWrongDesc, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Wrong picture')),
          value: isWrongPicture,
          onChanged: (bool) =>
              {isWrongPicture = !isWrongPicture, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Price is different from listing')),
          value: isWrongPrice,
          onChanged: (bool) => {isWrongPrice = !isWrongPrice, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Duplicate Ad')),
          value: isDuplicate,
          onChanged: (bool) => {isDuplicate = !isDuplicate, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Prohibited item')),
          value: isProhibited,
          onChanged: (bool) => {isProhibited = !isProhibited, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Counterfeit item')),
          value: isCounterfeit,
          onChanged: (bool) =>
              {isCounterfeit = !isCounterfeit, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Item no longer available')),
          value: isNoLongerAvailable,
          onChanged: (bool) =>
              {isNoLongerAvailable = !isNoLongerAvailable, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text(LocaleUtil.get('Unresponsive poster')),
          value: isUnresponsivePoster,
          onChanged: (bool) =>
              {isUnresponsivePoster = !isUnresponsivePoster, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: Text('Scam'),
          value: isScam,
          onChanged: (bool) => {isScam = !isScam, _refreshState()},
          controlAffinity: ListTileControlAffinity.leading),
      Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: TextField(
          style: BurmeseUtil.textStyle(context),
          controller: reasonController,
          decoration: new InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            hintText:
                UserPreferenceUtil.keyboardTypeEnum == KeyboardTypeEnum.Zawgyi
                    ? BurmeseUtil.toZawgyi(LocaleUtil.get('Write reason'))
                    : LocaleUtil.get('Write reason'),
          ),
          maxLength: 300,
          maxLines: 10,
          minLines: 3,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Container(
          width: double.infinity,
          child: CustomButton(
            onPressed: () => _reportAds(reasonController.text),
            text: LocaleUtil.get('Report Listing'),
            buttonTypeEnum: ButtonTypeEnum.primary,
          ),
        ),
      )
    ]);
  }

  _refreshState() {
    setState(() {});
  }
}
