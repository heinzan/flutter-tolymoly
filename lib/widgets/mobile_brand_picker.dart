import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tolymoly/api/mobile_brand_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/dto/mobile_brand_dto.dart';
import 'package:tolymoly/dto/mobile_brand_picker_dto.dart';
import 'package:tolymoly/dto/mobile_model_dto.dart';

class MobileBrandPicker extends StatefulWidget {
  final Function onTapModel;
  final bool isFilter;
  MobileBrandPicker.sell(this.onTapModel) : this.isFilter = false;

  MobileBrandPicker.filter(this.onTapModel) : this.isFilter = true;

  @override
  _MobileBrandPickerState createState() => _MobileBrandPickerState();
}

class _MobileBrandPickerState extends State<MobileBrandPicker> {
  int currentBrandId = 0;
  String currentBrandName;
  String textArrow = '<';
  String textChoose = 'Choose';
  String previousButtonText = '';
  List previousId = [0];
  bool isBrand = true;
  String title = 'Brand';
  String allLabel = '~ All ~';

  @override
  void initState() {
    previousButtonText = textChoose;
    super.initState();
  }

  Future<List<MobileBrandDto>> _getBrand() async {
    Response response = await MobileBrandApi.get();
    if (response.statusCode != 200) return null;

    var list = response.data as List;
    List<MobileBrandDto> brands =
        list.map((i) => MobileBrandDto.fromMap(i)).toList();
    if (widget.isFilter) brands.insert(0, MobileBrandDto(0, allLabel));
    return brands;
  }

  Future<List<MobileModelDto>> _getModel() async {
    // List<TownshipModel> townships =
    //     await TownshipRepository.find(currentBrandId);

    Response response = await MobileBrandApi.getModel(currentBrandId);
    if (response.statusCode != 200) return null;

    var list = response.data as List;
    List<MobileModelDto> models =
        list.map((i) => MobileModelDto.fromMap(i)).toList();

    if (widget.isFilter) models.insert(0, MobileModelDto(0, allLabel));
    return models;
  }

  void _selectBrand(int brandId, String brandName) async {
    isBrand = false;
    currentBrandId = brandId;
    currentBrandName = brandName;
    title = 'Model';

    // this.currentParentId = categoryId;
    // previousId.add(categoryId);
    previousButtonText = textArrow;
    setState(() {});
  }

  void _back() {
    previousButtonText = textChoose;

    if (isBrand) return;

    isBrand = true;
    title = 'Brand';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: ColorConstant.primary,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: new RaisedButton(
                  child: new Text(previousButtonText),
                  onPressed: () {
                    _back();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: isBrand ? _getBrand() : _getModel(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      int id = snapshot.data[index].id;
                      String name = snapshot.data[index].name;
                      return ListTile(
                        title: Text(name),
                        trailing:
                            isBrand ? Icon(Icons.keyboard_arrow_right) : null,
                        onTap: () {
                          if (isBrand) {
                            if (id == 0) {
                              MobileBrandPickerDto dto =
                                  new MobileBrandPickerDto();
                              dto.brandId = id;
                              dto.brandName = name;
                              widget.onTapModel(dto);
                              Navigator.pop(context);
                              return;
                            }
                            _selectBrand(id, name);
                          } else {
                            MobileBrandPickerDto dto =
                                new MobileBrandPickerDto();
                            dto.modelId = id;
                            dto.modelName = name;
                            dto.brandId = currentBrandId;
                            dto.brandName = currentBrandName;
                            widget.onTapModel(dto);
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
