import 'package:flutter/material.dart';
import 'package:tolymoly/dto/property_picker_dto.dart';
import 'package:tolymoly/models/property_sub_type_model.dart';
import 'package:tolymoly/models/property_type_model.dart';
import 'package:tolymoly/repositories/property_sub_type_repository.dart';
import 'package:tolymoly/repositories/property_type_repository.dart';

class PropertyPicker extends StatefulWidget {
  final Function onTapProperty;
  final bool isFilter;
  PropertyPicker.sell(this.onTapProperty) : this.isFilter = false;

  @override
  _PropertyPickerState createState() => _PropertyPickerState();
}

class _PropertyPickerState extends State<PropertyPicker> {
  int currentPropertyTypeId = 0;
  String currentPropertyName;
  String textArrow = '<';
  String textChoose = 'Choose';
  String previousButtonText = '';
  List previousId = [0];
  bool isPropertyType = true;
  String title = 'Property';
  String allLabel = '~ All ~';

  @override
  void initState() {
    previousButtonText = textChoose;
    super.initState();
  }

  Future<List<PropertyTypeModel>> _getPropertyType() async {
    List<PropertyTypeModel> propertyTypes = await PropertyTypeRepository.find();
    if (widget.isFilter)
      propertyTypes.insert(0, PropertyTypeModel(0, allLabel));
    return propertyTypes;
  }

  Future<List<PropertySubTypeModel>> _getPropertySubType() async {
    List<PropertySubTypeModel> propertySubTypes =
        await PropertySubTypeRepository.find(currentPropertyTypeId);
    if (widget.isFilter)
      propertySubTypes.insert(
          0, PropertySubTypeModel(0, allLabel, currentPropertyTypeId));
    return propertySubTypes;
  }

  void _selectPropertyType(int regionId, String regionName) async {
    isPropertyType = false;
    currentPropertyTypeId = regionId;
    currentPropertyName = regionName;
    title = 'Sub Type';

    // this.currentParentId = categoryId;
    // previousId.add(categoryId);
    previousButtonText = textArrow;
    setState(() {});
  }

  void _back() {
    previousButtonText = textChoose;

    if (isPropertyType) return;

    isPropertyType = true;
    title = 'Property Type';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
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
              future:
                  isPropertyType ? _getPropertyType() : _getPropertySubType(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print('snapshot.data...');
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
                        trailing: isPropertyType
                            ? Icon(Icons.keyboard_arrow_right)
                            : null,
                        onTap: () {
                          if (isPropertyType) {
                            if (id == 0) {
                              PropertyPickerDto dto = new PropertyPickerDto();
                              dto.propertyTypeId = id;
                              dto.propertyTypeName = name;
                              widget.onTapProperty(dto);
                              Navigator.pop(context);
                              return;
                            }
                            _selectPropertyType(id, name);
                          } else {
                            PropertyPickerDto dto = new PropertyPickerDto();
                            dto.propertySubTypeId = id;
                            dto.propertySubTypeName = name;
                            dto.propertyTypeId = currentPropertyTypeId;
                            dto.propertyTypeName = currentPropertyName;
                            widget.onTapProperty(dto);
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
