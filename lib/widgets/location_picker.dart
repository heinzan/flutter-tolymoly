import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/location_picker_dto.dart';
import 'package:tolymoly/models/region_model.dart';
import 'package:tolymoly/models/township_model.dart';
import 'package:tolymoly/repositories/region_repository.dart';
import 'package:tolymoly/repositories/township_repository.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class LocationPicker extends StatefulWidget {
  final Function onTapLocation;
  final bool isFilter;
  LocationPicker.sell(this.onTapLocation) : this.isFilter = false;

  LocationPicker.filter(this.onTapLocation) : this.isFilter = true;

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  int currentRegionId = 0;
  String currentRegionName;
  String textArrow = '<';
  String textChoose = LocaleUtil.get(LabelConstant.choose);
  String previousButtonText = '';
  List previousId = [0];
  bool isRegion = true;
  String title = LocaleUtil.get(LabelConstant.region);
  String allLabel = LocaleUtil.get('~ ${LabelConstant.all} ~');

  @override
  void initState() {
    previousButtonText = textChoose;
    super.initState();
  }

  Future<List<RegionModel>> _getRegion() async {
    print('_getRegion');
    List<RegionModel> regions =
        await RegionRepository.find(UserPreferenceUtil.displayLanguageTypeEnum);
    if (widget.isFilter) regions.insert(0, RegionModel(0, allLabel));
    return regions;
  }

  Future<List<TownshipModel>> _getTownship() async {
    print('_getTownship');
    List<TownshipModel> townships = await TownshipRepository.find(
        currentRegionId, UserPreferenceUtil.displayLanguageTypeEnum);
    if (widget.isFilter)
      townships.insert(0, TownshipModel(0, allLabel, currentRegionId));
    return townships;
  }

  void _selectRegion(int regionId, String regionName) async {
    isRegion = false;
    currentRegionId = regionId;
    currentRegionName = regionName;
    title = LocaleUtil.get(LabelConstant.township);

    // this.currentParentId = categoryId;
    // previousId.add(categoryId);
    previousButtonText = textArrow;
    setState(() {});
  }

  void _back() {
    previousButtonText = textChoose;

    if (isRegion) return;

    isRegion = true;
    title = LocaleUtil.get(LabelConstant.region);

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
              future: isRegion ? _getRegion() : _getTownship(),
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
                            isRegion ? Icon(Icons.keyboard_arrow_right) : null,
                        onTap: () {
                          if (isRegion) {
                            if (id == 0) {
                              LocationPickerDto dto = new LocationPickerDto();
                              dto.regionId = id;
                              dto.regionName = name;
                              widget.onTapLocation(dto);
                              Navigator.pop(context);
                              return;
                            }
                            _selectRegion(id, name);
                          } else {
                            LocationPickerDto dto = new LocationPickerDto();
                            dto.townshipId = id;
                            dto.townshipName = name;
                            dto.regionId = currentRegionId;
                            dto.regionName = currentRegionName;
                            widget.onTapLocation(dto);
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
