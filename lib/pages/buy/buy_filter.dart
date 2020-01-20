import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/buy_filter_dto.dart';
import 'package:tolymoly/enum/condition_enum.dart';
import 'package:tolymoly/enum/sort_enum.dart';
import 'package:tolymoly/models/buy_filter_model.dart';
import 'package:tolymoly/models/reference.dart';
import 'package:tolymoly/repositories/buy_filter_repository.dart';
import 'package:tolymoly/repositories/reference_repository.dart';
import 'package:tolymoly/services/buy_filter_service.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';

class BuyFilter extends StatefulWidget {
  final Function onTapFilter;
  final BuyFilterDto buyFilterDto;
  BuyFilter(this.onTapFilter, this.buyFilterDto);

  _BuyFilterState createState() => _BuyFilterState();
}

class _BuyFilterState extends State<BuyFilter> {
  Logger logger = new Logger();
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();
  int sortSelectedId = 0;
  int conditionSelectedId = 0;
  int priceTypeSelectedId = 1;
  bool isDataLoaded = false;
  List<Reference> priceTypes = new List<Reference>();
  List<Reference> conditions = new List<Reference>();
  List<Reference> sorts = new List<Reference>();
  // BuyFilterService _buyFilterService = new BuyFilterService();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Filter')),
        backgroundColor: ColorConstant.primary,
      ),
      body: isDataLoaded
          ? Column(
              children: <Widget>[
                _buildSorting(),
                _buildCondition(),
                _buildPrice(),
                _buildButton(),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  _getData() async {
    // BuyFilterModel buyFilterModel = await _buyFilterService.find();

    logger.d(widget.buyFilterDto.priceFrom.toString());

    if (widget.buyFilterDto != null) {
      sortSelectedId = widget.buyFilterDto.sortId;
      conditionSelectedId = widget.buyFilterDto.conditionId;
      priceTypeSelectedId = widget.buyFilterDto.priceTypeId;
      if (widget.buyFilterDto.priceFrom != null)
        priceFromController.text = widget.buyFilterDto.priceFrom.toString();
      if (widget.buyFilterDto.priceTo != null)
        priceToController.text = widget.buyFilterDto.priceTo.toString();
    }

    priceTypes = await ReferenceRepository.findPriceType();
    priceTypes.removeLast(); // remove usd
    conditions = await ReferenceRepository.findCondition();
    conditions.insert(0, Reference(0, ''));

    sorts.add(Reference(SortEnum.Null.index, ''));
    sorts.add(Reference(SortEnum.NewestFirst.index, 'Newest first'));
    sorts.add(Reference(SortEnum.PriceLowToHigh.index, 'Price (Low to High)'));
    sorts.add(Reference(SortEnum.PriceHighToLow.index, 'Price (High to Low)'));
    isDataLoaded = true;
    setState(() {});
  }

  _buildPrice() {
    return Padding(
        padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
        child: Row(
          children: <Widget>[
            Text(
              'Price',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10.0),
            Container(
                width: 100.0,
                child: TextField(
                  decoration: InputDecoration(hintText: 'from'),
                  controller: priceFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                )),
            Icon(Icons.keyboard_arrow_right),
            Container(
                width: 100.0,
                child: TextField(
                  decoration: InputDecoration(hintText: 'to'),
                  controller: priceToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                )),
            _buildPriceType()
          ],
        ));
  }

  _buildSorting() {
    return _buildDropdownRow(sorts, 'Sorting', sortSelectedId, _onTapSort);
  }

  _buildCondition() {
    // final items = {
    //   ConditionEnum.Null.index: '',
    //   ConditionEnum.New.index: 'New',
    //   ConditionEnum.Used.index: 'Used',
    // };

    return _buildDropdownRow(
        conditions, 'Condition', conditionSelectedId, _onTapCondition);
  }

  _buildPriceType() {
    return _buildDropdown(
        priceTypes, priceTypeSelectedId, false, _onTapPriceType);
  }

  _buildDropdownRow(
      List<Reference> items, labelName, int selectedIndex, Function callback) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            labelName,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildDropdown(items, selectedIndex, false, callback)
        ],
      ),
    );
  }

  _buildDropdown(List<Reference> items, int selectedIndex, bool isExpanded,
      Function function) {
    List<DropdownMenuItem<int>> menuItems = List();

    for (Reference reference in items) {
      menuItems.add(DropdownMenuItem<int>(
        // items[key] this instruction get the value of the respective key
        child: Text(reference.name), // the value as text label
        value: reference.id, // the respective key as value
      ));
    }

    return new DropdownButtonHideUnderline(
        child: DropdownButton<int>(
      isExpanded: isExpanded,
      value: selectedIndex == 0 ? null : selectedIndex,
      items: menuItems,
      onChanged: (value) {
        function(value);
        setState(() {});
      },
    ));
  }

  Widget _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {
                sortSelectedId = null;
                conditionSelectedId = null;
                priceTypeSelectedId = null;
                priceFromController.text = '';
                priceToController.text = '';
                setState(() {});
              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "CLEAR",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              onPressed: () {
                BuyFilterDto dto = new BuyFilterDto();
                dto.conditionId = conditionSelectedId;
                dto.priceTypeId = priceTypeSelectedId;
                dto.sortId = sortSelectedId;
                if (priceFromController.text == null ||
                    priceFromController.text.trim().isEmpty) {
                  dto.priceFrom = null;
                } else {
                  dto.priceFrom = int.parse(priceFromController.text);
                }

                if (priceToController.text == null ||
                    priceToController.text.isEmpty) {
                  dto.priceTo = null;
                } else {
                  dto.priceTo = int.parse(priceToController.text);
                }

                // BuyFilterModel model = new BuyFilterModel();
                // model.conditionId = conditionSelectedId;
                // model.sortId = sortSelectedId;
                // model.priceType = priceTypeSelectedId;

                widget.onTapFilter(dto);
                Navigator.pop(context);
              },
              color: Colors.orange[600],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "APPLY",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTapSort(int selectedIndex) {
    sortSelectedId = selectedIndex;
  }

  _onTapCondition(int selectedIndex) {
    conditionSelectedId = selectedIndex;
  }

  _onTapPriceType(int selectedIndex) {
    priceTypeSelectedId = selectedIndex;
  }
}
