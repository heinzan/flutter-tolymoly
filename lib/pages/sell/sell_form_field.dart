import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/dto/attribute_dto2.dart';
import 'package:tolymoly/dto/location_picker_dto.dart';
import 'package:tolymoly/dto/mobile_brand_picker_dto.dart';
import 'package:tolymoly/dto/property_picker_dto.dart';
import 'package:tolymoly/dto/reference_dto.dart';
import 'package:tolymoly/enum/ad_button_enum.dart';
import 'package:tolymoly/enum/ad_status_enum.dart';
import 'package:tolymoly/enum/attribute_type.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/enum/input_type.dart';
import 'package:tolymoly/models/attribute_model.dart';
import 'package:tolymoly/pages/sell/sell_dropdown.dart';
import 'package:tolymoly/repositories/reference_repository.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/dialog_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/price_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';
import 'package:tolymoly/widgets/location_picker.dart';
import 'package:tolymoly/widgets/mobile_brand_picker.dart';

class SellFormField extends StatefulWidget {
  final bool isNewAd;
  final int adId;
  final int categoryId;
  final adData;
  final Function onSubmitForm;
  SellFormField.fromNew(this.categoryId, this.adData, this.onSubmitForm)
      : this.isNewAd = true,
        this.adId = null;
  SellFormField.fromEdit(this.adId, this.adData, this.onSubmitForm)
      : this.categoryId = null,
        this.isNewAd = false;

  _SellFormFieldState createState() => _SellFormFieldState();
}

class _SellFormFieldState extends State<SellFormField> {
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<Widget> fieldList = new List<Widget>();
  Map<String, TextEditingController> controllerMap =
      new Map<String, TextEditingController>();
  Map<String, AttributeModel> attributeMap = new Map<String, AttributeModel>();
  Map<String, dynamic> idMap = new Map<String, dynamic>();
  UserPreferenceService userPreferenceService = UserPreferenceService();
  // Ad ad = new Ad();
  static const String photoAttribute = 'photo';
  static const String conditionAttribute = 'conditionId';
  static const String regionAttribute = 'regionId';
  static const String townshipAttribute = 'townshipId';
  static const String priceAttribute = 'price';
  static const String priceTypeAttribute = 'priceType';
  static const String titleAttribute = 'title';
  static const String descriptionAttribute = 'description';
  static const String brandAttribute = 'brand';
  static const String propertyTypeAttribute = 'propertyTypeId';
  static const String propertySubTypeAttribute = 'propertySubTypeId';
  static const String transactionTypeIdAttribute = 'transactionTypeId';
  static const String mobileBrandAttribute = 'mobileBrandId';
  static const String mobileModelAttribute = 'mobileModelId';

  final String regionTownshipTitle = 'Region/township';

  static String postLabel = LocaleUtil.get('Post');
  static String draftLabel = LocaleUtil.get('Save as Draft');
  static String updateLabel = LocaleUtil.get('Update');
  static String activateLabel = LocaleUtil.get('Activate');
  static String deactivateLabel = LocaleUtil.get('Deactivate');
  static String markAsSoldLabel = LocaleUtil.get('Mark as Sold');
  static String deleteLabel = LocaleUtil.get('Delete');

  var logger = Logger();
  String pleaseEnter = LocaleUtil.get('Please enter');
  // List<AttributeDto> attributes = new List<AttributeDto>();
  List<AttributeDto2> attributes;

  // bool isNewAd = false;

  @override
  void initState() {
    print('SellFormField > initState');

    // isNewAd = widget.ad['adId'] == null ? true : false;

    // if (widget.ad['categoryId'] != null) _init();
    _init();
    // pleaseEnter = LocaleUtil.get('Please enter');

    super.initState();
  }

  Future _init() async {
    await _initForm();
    await _setEditData();
  }

  _setAttribute(List list) {
    attributes = list.map((i) => AttributeDto2.fromMap(i)).toList();
  }

  _initForm() async {
    print('SellFormField > _initForm');

    var list;
    if (widget.isNewAd) {
      var list = widget.adData as List;
      _setAttribute(list);
    } else {
      var list = widget.adData['attributes'] as List;
      _setAttribute(list);
    }

    for (var i = 0; i < attributes.length; i++) {
      print(attributes[i].name);
      // print(listAttribute[i].labelName);
      // ReCase rc = new ReCase(attributes[i].name);

      String name = attributes[i].name;
      String label = attributes[i].label;
      // String table = attributes[i].tableName;
      bool isRequired = attributes[i].isRequired;
      int type = attributes[i].type;
      int inputType = attributes[i].inputType;
      List referenceDtos = attributes[i].referenceDtos;
      String value = attributes[i].value;
      String mobileBrandId;

      String editValue;
      if (!widget.isNewAd) {
        // ReCase rc = new ReCase(name);
        // String dataName = rc.camelCase;
        // var dataValue = value;
        if (value != null) {
          if (name == 'price') {
            editValue = PriceUtil.value(double.parse(value));
          } else {
            editValue = value;
          }
        }
      }

      TextEditingController controller = new TextEditingController();

      switch (name) {
        case photoAttribute:
          // do nothing
          break;
        case regionAttribute:
          // region name is not shown
          if (editValue == null) {
            idMap[name] = UserPreferenceUtil.sellRegionId;
          } else {
            idMap[name] = editValue;
          }
          controller = new TextEditingController(text: name);
          break;
        case townshipAttribute:
          String editName;
          if (editValue == null) {
            idMap[name] = UserPreferenceUtil.sellTownshipId;
            editName = UserPreferenceUtil.sellTownshipName;
          } else {
            idMap[name] = editValue;
            editName = await ReferenceRepository.findName(
                'township', int.parse(editValue));
          }
          controller = new TextEditingController(text: editName);
          _buildTownship(isRequired, controller, label);
          break;
        case priceTypeAttribute:
          String editName;

          if (editValue == null) {
            int priceTypeId = 1; //kyat
            editName = _getName(referenceDtos, priceTypeId);
            idMap[name] = priceTypeId;
          } else {
            idMap[name] = editValue;
            editName = _getName(referenceDtos, int.parse(editValue));
          }

          controller = new TextEditingController(text: editName);
          _buildDropdown(isRequired, controller, name, label, referenceDtos);
          break;
        case mobileBrandAttribute:
          // mobile brand name is not shown
          if (editValue == null) {
            // idMap[name] = UserPreferenceUtil.sellRegionId;
          } else {
            idMap[name] = editValue;
          }
          controller = new TextEditingController(text: name);
          break;
        case mobileModelAttribute:
          String editName;
          if (editValue == null) {
            // idMap[name] = UserPreferenceUtil.sellTownshipId;
            // editName = UserPreferenceUtil.sellTownshipName;
          } else {
            idMap[name] = editValue;
            editName = _getName(referenceDtos, int.parse(editValue));

            // editName =
            //     await ReferenceRepository.findName('township', editValue);
          }
          controller = new TextEditingController(text: editName);
          _buildMobileModel(isRequired, controller, label);
          break;

        case propertyTypeAttribute:
          // do nothing
          break;
        // case propertySubTypeAttribute:
        //   break;
        case transactionTypeIdAttribute:
          // do nothing
          break;
        default:
          if (type == AttributeTypeEnum.Text.index) {
            TextInputType textInputType;

            if (inputType == InputTypeEnum.Text.index) {
              textInputType = TextInputType.text;
            } else if (inputType == InputTypeEnum.Number.index) {
              textInputType = TextInputType.number;
            }

            if (editValue == null) {
              editValue = '';
            } else {
              editValue = BurmeseUtil.toZawgyi(editValue.toString());
            }

            controller = new TextEditingController(text: editValue);

            if (name == titleAttribute) {
              _buildTextFormField(
                  isRequired, controller, label, textInputType, false, 80);
            } else if (name == descriptionAttribute) {
              _buildDescription(isRequired, controller, label);
            } else {
              _buildTextFormField(
                  isRequired, controller, label, textInputType, false, null);
            }
          } else if (type == AttributeTypeEnum.Select.index) {
            String editName;

            if (editValue == null) {
              idMap[name] = null;
              editValue = '';
            } else {
              idMap[name] = editValue;

              // if (name == mobileModelAttribute) {
              //   if (mobileBrandId != null) {
              //     Response response =
              //         await MobileBrandApi.getModel(int.parse(mobileBrandId));
              //     if (response.statusCode != 200) return;

              //     referenceDtos =
              //         list.map((i) => AttributeDto2.fromMap(i)).toList();
              //   }
              // }

              editName = _getName(referenceDtos, int.parse(editValue));
            }

            controller = new TextEditingController(text: editName);

            _buildDropdown(isRequired, controller, name, label, referenceDtos);
          }
      }

      controllerMap[name] = controller;
    }
    logger.d('SellFormField > _initForm > end........');
  }

  String _getName(List<ReferenceDto> list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) return list[i].name;
    }

    return '';
  }

  _setEditData() async {
    print('_setData...');

    if (widget.isNewAd) {
      _buildButtons(null);
      setState(() {});

      return;
    }

    fieldList.add(SizedBox(height: 20));
    _buildButtons(widget.adData['adStatus']);
    fieldList.add(SizedBox(height: 40));

    setState(() {});
  }

  _buildTownship(
      bool isRequired, TextEditingController controller, String label) {
    if (isRequired) label = '* $label';

    fieldList.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new LocationPicker.sell(ontapLocation)));
        },
        child: AbsorbPointer(
            child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          validator: (value) {
            if (isRequired && value.isEmpty) {
              return pleaseEnter;
            }
            return null;
          },
        ))));
  }

  _buildMobileModel(
      bool isRequired, TextEditingController controller, String label) {
    if (isRequired) label = '* $label';

    fieldList.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new MobileBrandPicker.sell(ontapMobileBrand)));
        },
        child: AbsorbPointer(
            child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          validator: (value) {
            if (isRequired && value.isEmpty) {
              return pleaseEnter;
            }
            return null;
          },
        ))));
  }

  // _buildProperty(
  //     bool isRequired, TextEditingController controller, String label) {
  //   if (isRequired) label = '* $label';

  //   fieldList.add(GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) =>
  //                     new PropertyPicker.sell(onTapProperty)));
  //       },
  //       child: AbsorbPointer(
  //           child: TextFormField(
  //         controller: controller,
  //         decoration: InputDecoration(labelText: label),
  //         validator: (value) {
  //           if (isRequired && value.isEmpty) {
  //             return pleaseEnter;
  //           }
  //           return null;
  //         },
  //       ))));
  // }

  _buildTextFormField(
      bool isRequired,
      TextEditingController controller,
      String label,
      TextInputType textInputType,
      bool digitsOnly,
      int maxLength) {
    label = BurmeseUtil.toZawgyi(label);

    if (isRequired) label = '* $label';
    fieldList.add(TextFormField(
      style: BurmeseUtil.textStyle(context),
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: textInputType,
      maxLength: maxLength,
      inputFormatters: <TextInputFormatter>[
        if (digitsOnly) WhitelistingTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (isRequired && value.isEmpty) {
          return pleaseEnter;
        }
        return null;
      },
    ));
  }

  _buildDescription(
      bool isRequired, TextEditingController controller, String label) {
    label = BurmeseUtil.toZawgyi(label);

    if (isRequired) label = '* $label';

    fieldList.add(Container(
      // color: Colors.gray,
      // padding: new EdgeInsets.all(7.0),

      child: new ConstrainedBox(
        constraints: new BoxConstraints(
            // minWidth: _contextWidth(),
            // maxWidth: _contextWidth(),
            // minHeight: AppMeasurements.isLandscapePhone(context) ? 25.0 : 25.0,
            // maxHeight: 55.0,
            // minHeight: 100,
            ),
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,

          // here's the actual text box
          child: new TextField(
            style: BurmeseUtil.textStyle(context),
            keyboardType: TextInputType.multiline,
            maxLines: null, //grow automatically
            maxLength: 1000,
            // focusNode: mrFocus,
            controller: controller,
            decoration: InputDecoration(labelText: label),
            // onSubmitted: currentIsComposing ? _handleSubmitted : null,
          ),
        ),
      ),
    ));
  }

  void _buildDropdown(bool isRequired, TextEditingController controller,
      String name, String label, List<ReferenceDto> referenceDtos) {
    fieldList.add(SellDropdown2(
        isRequired, name, label, onTapDropdown, controller, referenceDtos));
  }

  void onTapDropdown(
      String attributeName, int selectedId, String selectedName) {
    controllerMap[attributeName].text = selectedName;
    idMap[attributeName] = selectedId;
  }

  void ontapLocation(LocationPickerDto dto) {
    controllerMap[regionAttribute].text = dto.regionName;
    idMap[regionAttribute] = dto.regionId;

    controllerMap[townshipAttribute].text = dto.townshipName;
    idMap[townshipAttribute] = dto.townshipId;

    userPreferenceService.updateSellLocation(dto);
  }

  void ontapMobileBrand(MobileBrandPickerDto dto) {
    controllerMap[mobileBrandAttribute].text = dto.brandName;
    idMap[mobileBrandAttribute] = dto.brandId;

    controllerMap[mobileModelAttribute].text = dto.modelName;
    idMap[mobileModelAttribute] = dto.modelId;
  }

  void onTapProperty(PropertyPickerDto dto) {
    controllerMap[propertySubTypeAttribute].text = dto.propertySubTypeName;
    idMap[propertySubTypeAttribute] = dto.propertySubTypeId;
  }

  Future _save(AdButtonEnum enumValue) async {
    int categoryId;
    if (widget.isNewAd) {
      categoryId = widget.categoryId;
    } else {
      categoryId = widget.adData['categoryId'];
    }
    String data = '"categoryId":$categoryId';

    if (widget.adId != null) data = '$data,"adId":${widget.adId}';

    for (int i = 0; i < attributes.length; i++) {
      AttributeDto2 dto = attributes[i];
      String key = dto.name;
      String value;
      if (dto.type == AttributeTypeEnum.Text.index) {
        value = controllerMap[key].text;

        if (value != null) {
          value = value.trim();

          if (value == '') {
            value = null;
          } else {
            if (key == 'price') value = value.replaceAll(',', '');

            if (dto.inputType == InputTypeEnum.Text.index) value = '"$value"';
          }
        }
      } else {
        value = idMap[key].toString();
      }

      String keyValue = '"$key":$value';

      print('type: ${dto.type}, keyValue: $keyValue');

      data = '$data,$keyValue';
    }

    // controllerMap.forEach((k, v) {
    //   String key = k;
    //   String value = controllerMap[k].text;
    //   print('controllerMap key: $key, value: $value');
    //   if (value != null && value.trim().isNotEmpty) {
    //     print('idMap key: $key, value: $value');

    //     if (idMap.containsKey(key)) {
    //       value = idMap[key].toString();
    //       value = '$value';
    //     } else {
    //       if (k == 'price') {
    //         value = value.replaceAll(',', '');
    //       }
    //       value = '"${value.trim()}"';
    //     }

    //     // ReCase rc = new ReCase(key);
    //     // key = rc.camelCase;

    //     String keyValue = '"$key":$value';

    //     data = '$data,$keyValue';
    //   }
    // });

    // data = '{$data,"adStatus":1}';
    data = '{$data}';
    print(data);
    widget.onSubmitForm(enumValue, data);
  }

  void _buildButtons(int adStatus) {
    fieldList.add(SizedBox(
      height: 10,
    ));

    if (widget.isNewAd) {
      _buildButton(AdButtonEnum.post, ButtonTypeEnum.primary);
      fieldList.add(new Text(LocaleUtil.get('OR')));
      _buildButton(AdButtonEnum.draft, ButtonTypeEnum.origin);
    } else {
      if (adStatus == AdStatusEnum.active.index) {
        _buildButton(AdButtonEnum.update, ButtonTypeEnum.primary);
        fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.deactivate, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.markAsSold, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      } else if (adStatus == AdStatusEnum.draft.index) {
        _buildButton(AdButtonEnum.update, ButtonTypeEnum.primary);
        fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.post, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      } else if (adStatus == AdStatusEnum.sold.index) {
        _buildButton(AdButtonEnum.active, ButtonTypeEnum.primary);
        fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.deactivate, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      } else if (adStatus == AdStatusEnum.rejected.index) {
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.primary);
      } else if (adStatus == AdStatusEnum.inactive.index) {
        _buildButton(AdButtonEnum.update, ButtonTypeEnum.primary);
        fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.active, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.markAsSold, ButtonTypeEnum.origin);
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      } else if (adStatus == AdStatusEnum.pending.index) {
        _buildButton(AdButtonEnum.update, ButtonTypeEnum.primary);
        fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      } else if (adStatus == AdStatusEnum.reported.index) {
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.primary);
      } else if (adStatus == AdStatusEnum.verification_lock.index) {
        // _buildButton(AdButtonEnum.update, ButtonTypeEnum.primary);
        // fieldList.add(new Text(LocaleUtil.get('OR')));
        _buildButton(AdButtonEnum.delete, ButtonTypeEnum.origin);
      }
    }
  }

  void _buildButton(AdButtonEnum enumValue, ButtonTypeEnum buttonTypeEnum) {
    String labelName;
    switch (enumValue) {
      case AdButtonEnum.post:
        labelName = postLabel;
        break;
      case AdButtonEnum.update:
        labelName = updateLabel;
        break;
      case AdButtonEnum.draft:
        labelName = draftLabel;
        break;
      case AdButtonEnum.delete:
        labelName = deleteLabel;
        break;
      case AdButtonEnum.deactivate:
        labelName = deactivateLabel;
        break;
      case AdButtonEnum.active:
        labelName = activateLabel;
        break;
      case AdButtonEnum.markAsSold:
        labelName = markAsSoldLabel;
        break;
    }
    fieldList.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: CustomButton(
            text: labelName,
            buttonTypeEnum: buttonTypeEnum,
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                ToastUtil.error(LocaleUtil.get('Please enter required field'));
                return;
              }

              if (enumValue == AdButtonEnum.delete) {
                bool isDelete = await DialogUtil.confirmation(
                    context, LocaleUtil.get('Delete'));
                if (!isDelete) return;
              }

              _save(enumValue);
            }),
      ),
    );
  }

  // void _validate() {
  //   for (var i = 0; i < attributes.length; i++) {
  //     String name = attributes[i].name;
  //     bool isRequired = attributes[i].isRequired;
  //     if (isRequired && ['', null].contains(controllerMap[name].text)) {
  //       ToastUtil.error('Please enter required field');
  //       return;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: listField,
    // );

    return Form(
        key: _formKey,

        // autovalidate: true,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: fieldList,
          ),
        ));
  }
}
