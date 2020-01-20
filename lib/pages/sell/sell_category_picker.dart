import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/dto/category_picker_dto.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/category_model.dart';
import 'package:tolymoly/repositories/category_repository.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class SellCategoryPicker extends StatefulWidget {
  SellCategoryPicker();
  // final bool isSell;
  // final bool isFilter;
  // SellCategoryPicker.sell()
  //     : isSell = true,
  //       isFilter = false,
  //       onTapCategory = null;
  // SellCategoryPicker.filter(onTapCategory)
  //     : isSell = false,
  //       isFilter = true,
  //       onTapCategory = onTapCategory;

  @override
  _SellCategoryPickerState createState() => _SellCategoryPickerState();
}

class _SellCategoryPickerState extends State<SellCategoryPicker> {
  Logger logger = new Logger();
  List<CategoryModel> naviCategories = new List<CategoryModel>();
  List<CategoryModel> categories = new List();

  @override
  void initState() {
    print('SellCategoryPicker > initState');

    CategoryModel catAll = new CategoryModel();
    catAll.id = 0;
    catAll.name = LocaleUtil.get(LabelConstant.all);
    catAll.mmUnicode = LocaleUtil.get(LabelConstant.all);
    catAll.hasChild = false;

    naviCategories.add(catAll);

    _getData();

    super.initState();
  }

  void _getData() async {
    categories =
        await CategoryRepository.findByParentId(naviCategories.last.id);
    setState(() {});
  }

  void _previousCategory(int index) {
    if (index == naviCategories.length - 1) return;
    naviCategories.removeRange(index + 1, naviCategories.length);
    _getData();
    // setState(() {});
  }

  List<Widget> _buildNavigation() {
    List<Widget> list = List();
    list.add(SizedBox(width: 10));

    for (int i = 0; i < naviCategories.length; i++) {
      String label;
      if (UserPreferenceUtil.displayLanguageTypeEnum ==
          DisplayLanguageTypeEnum.English) {
        label = naviCategories[i].name;
      } else {
        label = naviCategories[i].mmUnicode;
      }
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
    return new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(LocaleUtil.get('Category')),
          backgroundColor: ColorConstant.primary,
          iconTheme: IconThemeData(
            color: ColorConstant.appBarIcon,
          ),
        ),
        body: Column(
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
                  if (UserPreferenceUtil.displayLanguageTypeEnum ==
                      DisplayLanguageTypeEnum.English) {
                    name = category.name;
                  } else {
                    name = category.mmUnicode;
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
                        _getData();

                        // setState(() {});
                      } else {
                        CategoryPickerDto dto = new CategoryPickerDto();
                        dto.id = category.id;
                        dto.name = category.name;
                        dto.mmUnicode = category.mmUnicode;
                        dto.isNewAd = false;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             new SellForm.fromCategory(dto)));
                        Navigator.pushNamed(
                            context, RouteConstant.sellFormFromCategory,
                            arguments: dto);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
