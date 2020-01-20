import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/category_model.dart';
import 'package:tolymoly/repositories/category_repository.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class BuyCategoryPicker extends StatefulWidget {
  final Function onTapCategory;
  final int categoryId;
  BuyCategoryPicker(this.onTapCategory, this.categoryId);
  // BuyCategoryPicker.withSelection(this.onTapCategory, this.categoryId);
  // final bool isSell;
  // final bool isFilter;
  // CategoryPicker.sell()
  //     : isSell = true,
  //       isFilter = false,
  //       onTapCategory = null;
  // CategoryPicker.filter(onTapCategory)
  //     : isSell = false,
  //       isFilter = true,
  //       onTapCategory = onTapCategory;

  @override
  _BuyCategoryPickerState createState() => _BuyCategoryPickerState();
}

class _BuyCategoryPickerState extends State<BuyCategoryPicker> {
  List<CategoryModel> naviCategories = new List<CategoryModel>();
  String allLabel;
  bool isDataLoaded = false;
  List<CategoryModel> categories;

  @override
  void initState() {
    print('BuyCategoryPicker > initState...');
    allLabel = LocaleUtil.get('~ ${LabelConstant.all} ~');

    CategoryModel catAll = new CategoryModel();
    catAll.id = 0;
    catAll.name = 'All';
    catAll.hasChild = false;

    naviCategories.add(catAll);

    _getData();

    super.initState();
  }

  void _getData() async {
    // List<Category> categories = await CategoryRepository.find(currentParentId);

    await _getSelectedData();

    await _getCategorydata();

    isDataLoaded = true;
    setState(() {});
  }

  Future<void> _getCategorydata() async {
    categories =
        await CategoryRepository.findByParentId(naviCategories.last.id);

    CategoryModel catAll = new CategoryModel();
    catAll.categoryIdLevel1 = naviCategories.last.categoryIdLevel1;
    catAll.categoryIdLevel2 = naviCategories.last.categoryIdLevel2;
    catAll.categoryIdLevel3 = naviCategories.last.categoryIdLevel3;
    catAll.id = naviCategories.last.id;
    // catAll.name = LocaleUtil.get('~ ${LabelConstant.all} ~');
    // catAll.mmUnicode = LocaleUtil.get('~ ${LabelConstant.all} ~');
    catAll.name = naviCategories.last.name;
    catAll.mmUnicode = naviCategories.last.mmUnicode;
    catAll.hasChild = false;
    categories.insert(0, catAll);
  }

  Future<void> _getSelectedData() async {
    if (widget.categoryId == null || widget.categoryId == 0) return;

    CategoryModel model = await CategoryRepository.findById(widget.categoryId);
    if (model.categoryIdLevel1 != null) {
      CategoryModel modelLevel1 =
          await CategoryRepository.findById(model.categoryIdLevel1);
      naviCategories.add(modelLevel1);
    }
    if (model.categoryIdLevel2 != null) {
      CategoryModel modelLevel2 =
          await CategoryRepository.findById(model.categoryIdLevel2);
      naviCategories.add(modelLevel2);
    }

    if (model.categoryIdLevel3 != null) {
      CategoryModel modelLevel3 =
          await CategoryRepository.findById(model.categoryIdLevel3);
      naviCategories.add(modelLevel3);
    }
  }

  void _previousCategory(int index) async {
    if (index == naviCategories.length - 1) return;
    naviCategories.removeRange(index + 1, naviCategories.length);

    await _getCategorydata();

    setState(() {});
  }

  List<Widget> _buildNavigation() {
    List<Widget> list = List();
    if (naviCategories.length == 1) return list;

    list.add(SizedBox(width: 10));

    for (int i = 0; i < naviCategories.length; i++) {
      String label = naviCategories[i].name;
      Color fontColor =
          i == naviCategories.length - 1 ? Colors.black : Colors.blue;
      list.add(InkWell(
          onTap: () => _previousCategory(i),
          child: Chip(
            label:
                Text(label, style: TextStyle(fontSize: 18, color: fontColor)),
            // style: TextStyle(fontSize: 18, color: fontColor),
          )));
      list.add(SizedBox(width: 10));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    print('BuyCategoryPicker > build...');

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Category'),
          backgroundColor: ColorConstant.primary,
          iconTheme: IconThemeData(
            color: ColorConstant.appBarIcon,
          ),
        ),
        body: isDataLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: _buildNavigation(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        CategoryModel category = categories[index];
                        String name;
                        if (index == 0) {
                          name = allLabel;
                        } else {
                          if (UserPreferenceUtil.displayLanguageTypeEnum ==
                              DisplayLanguageTypeEnum.English) {
                            name = category.name;
                          } else {
                            name = category.mmUnicode;
                          }
                        }

                        return ListTile(
                          title: Text(name),
                          trailing: category.hasChild
                              ? Icon(Icons.keyboard_arrow_right)
                              : null,
                          onTap: () {
                            if (category.hasChild) {
                              // _selectCategory(snapshot.data[index].id);
                              // _selectCategory(category);
                              naviCategories.add(category);
                              _getCategorydata();
                              setState(() {});
                            } else {
                              CategoryPickerDto dto = new CategoryPickerDto();
                              dto.id = category.id;
                              dto.name = category.name;
                              dto.categoryIdLevel1 = category.categoryIdLevel1;
                              dto.categoryIdLevel2 = category.categoryIdLevel2;
                              dto.categoryIdLevel3 = category.categoryIdLevel3;

                              widget.onTapCategory(dto);

                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
