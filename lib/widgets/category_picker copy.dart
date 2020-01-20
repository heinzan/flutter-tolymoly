// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:tolymoly/dto/category_picker_dto.dart';
// import 'package:tolymoly/models/category.dart';
// import 'package:tolymoly/pages/sell/sell_form.dart';
// import 'package:tolymoly/repositories/category_repository.dart';

// class CategoryPickerCopy extends StatefulWidget {
//   final Function onTapCategory;
//   final bool isSell;
//   final bool isFilter;
//   CategoryPickerCopy.sell()
//       : isSell = true,
//         isFilter = false,
//         onTapCategory = null;
//   CategoryPickerCopy.filter(onTapCategory)
//       : isSell = false,
//         isFilter = true,
//         onTapCategory = onTapCategory;

//   @override
//   _CategoryPickerCopyState createState() => _CategoryPickerCopyState();
// }

// class _CategoryPickerCopyState extends State<CategoryPickerCopy> {
//   // int currentCategoryId = 0;
//   Logger logger = new Logger();
//   int currentParentId = 0;
//   Category currentCategory;
//   String textArrow = '<';
//   String textChoose = 'Choose';
//   String previousButtonText = '';
//   List previousId = [0];
//   String allLabel = '~ All ~';

//   @override
//   void initState() {
//     currentCategory = new Category();
//     currentCategory.id = 0;
//     currentCategory.name = allLabel;
//     currentCategory.hasChild = false;

//     previousButtonText = textChoose;
//     super.initState();
//   }

//   Future<List<Category>> _getCategories() async {
//     print('_getCategories');
//     // List<Category> categories = await CategoryRepository.find(currentParentId);
//     List<Category> categories =
//         await CategoryRepository.find(currentCategory.id);

//     if (widget.isFilter) {
//       Category category = new Category();
//       category.id = currentCategory.id;
//       category.categoryIdLevel1 = currentCategory.categoryIdLevel1;
//       category.categoryIdLevel2 = currentCategory.categoryIdLevel2;
//       category.categoryIdLevel3 = currentCategory.categoryIdLevel3;
//       category.name = allLabel;
//       category.hasChild = false;
//       categories.insert(0, category);
//     }
//     return categories;
//   }

//   // void _selectCategory(int categoryId) async {
//   //   this.currentParentId = categoryId;
//   //   previousId.add(categoryId);
//   //   previousButtonText = textArrow;
//   //   setState(() {});
//   // }

//   void _selectCategory(Category category) async {
//     this.currentCategory = category;

//     previousId.add(category.id);
//     previousButtonText = textArrow;
//     setState(() {});
//   }

//   void _previousCategory() {
//     if (previousId.length == 1) return;

//     previousId.removeLast();

//     currentParentId = previousId[previousId.length - 1];

//     previousButtonText = previousId.length > 1 ? textArrow : textChoose;

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Category'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               new Container(
//                 margin: const EdgeInsets.only(left: 15.0),
//                 child: new RaisedButton(
//                   child: new Text(previousButtonText),
//                   onPressed: () {
//                     _previousCategory();
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: _getCategories(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 print('snapshot.data...');
//                 if (snapshot.data == null) {
//                   print('no data...');

//                   return Container(child: Center(child: Text("Loading...")));
//                 } else {
//                   print('has data...');

//                   return ListView.builder(
//                     // scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       Category category = snapshot.data[index];
//                       return ListTile(
//                         title: Text(category.name),
//                         trailing: category.hasChild
//                             ? Icon(Icons.keyboard_arrow_right)
//                             : null,
//                         onTap: () {
//                           if (category.hasChild) {
//                             // _selectCategory(snapshot.data[index].id);
//                             _selectCategory(category);
//                           } else {
//                             CategoryPickerDto dto = new CategoryPickerDto();
//                             dto.id = category.id;
//                             dto.name = category.name;
//                             dto.isNewAd = false;

//                             if (widget.isSell) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           new SellForm.fromCategory(dto)));
//                             } else if (widget.isFilter) {
//                               dto.categoryIdLevel1 = category.categoryIdLevel1;
//                               dto.categoryIdLevel2 = category.categoryIdLevel2;
//                               dto.categoryIdLevel3 = category.categoryIdLevel3;
//                               widget.onTapCategory(dto);

//                               Navigator.pop(context);
//                             }
//                           }
//                         },
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
