// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:tolymoly/dto/category_picker_dto.dart';
// import 'package:tolymoly/models/category._model.dart';
// import 'package:tolymoly/repositories/category_repository.dart';

// class CategoryPicker extends StatefulWidget {
//   final Function onTapCategory;
//   CategoryPicker(this.onTapCategory);
//   // final bool isSell;
//   // final bool isFilter;
//   // CategoryPicker.sell()
//   //     : isSell = true,
//   //       isFilter = false,
//   //       onTapCategory = null;
//   // CategoryPicker.filter(onTapCategory)
//   //     : isSell = false,
//   //       isFilter = true,
//   //       onTapCategory = onTapCategory;

//   @override
//   _CategoryPickerState createState() => _CategoryPickerState();
// }

// class _CategoryPickerState extends State<CategoryPicker> {
//   Logger logger = new Logger();
//   List<CategoryModel> naviCategories = new List<CategoryModel>();

//   @override
//   void initState() {
//     CategoryModel catAll = new CategoryModel();
//     catAll.id = 0;
//     catAll.name = 'All';
//     catAll.hasChild = false;

//     naviCategories.add(catAll);

//     super.initState();
//   }

//   Future<List<CategoryModel>> _getData() async {
//     print('_getData');
//     // List<Category> categories = await CategoryRepository.find(currentParentId);

//     List<CategoryModel> categories =
//         await CategoryRepository.find(naviCategories.last.id);

//     CategoryModel catAll = new CategoryModel();
//     catAll.categoryIdLevel1 = naviCategories.last.categoryIdLevel1;
//     catAll.categoryIdLevel2 = naviCategories.last.categoryIdLevel2;
//     catAll.categoryIdLevel3 = naviCategories.last.categoryIdLevel3;
//     catAll.id = naviCategories.last.id;
//     catAll.name = '~ All ~';
//     catAll.hasChild = false;
//     categories.insert(0, catAll);

//     return categories;
//   }

//   void _previousCategory(int index) {
//     if (index == naviCategories.length - 1) return;
//     naviCategories.removeRange(index + 1, naviCategories.length);

//     setState(() {});
//   }

//   List<Widget> _buildNavigation() {
//     List<Widget> list = List();
//     if (naviCategories.length == 1) return list;

//     list.add(SizedBox(width: 10));

//     for (int i = 0; i < naviCategories.length; i++) {
//       String label = naviCategories[i].name;
//       Color fontColor =
//           i == naviCategories.length - 1 ? Colors.black : Colors.blue;
//       list.add(InkWell(
//           onTap: () => _previousCategory(i),
//           child: Chip(
//             label:
//                 Text(label, style: TextStyle(fontSize: 18, color: fontColor)),
//             // style: TextStyle(fontSize: 18, color: fontColor),
//           )));
//       list.add(SizedBox(width: 10));
//     }

//     return list;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Category'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Wrap(
//             children: _buildNavigation(),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: _getData(),
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
//                       CategoryModel category = snapshot.data[index];
//                       return ListTile(
//                         title: Text(category.name),
//                         trailing: category.hasChild
//                             ? Icon(Icons.keyboard_arrow_right)
//                             : null,
//                         onTap: () {
//                           if (category.hasChild) {
//                             // _selectCategory(snapshot.data[index].id);
//                             // _selectCategory(category);
//                             naviCategories.add(category);
//                             setState(() {});
//                           } else {
//                             CategoryPickerDto dto = new CategoryPickerDto();
//                             dto.id = category.id;
//                             dto.name = category.name;
//                             dto.categoryIdLevel1 = category.categoryIdLevel1;
//                             dto.categoryIdLevel2 = category.categoryIdLevel2;
//                             dto.categoryIdLevel3 = category.categoryIdLevel3;

//                             widget.onTapCategory(dto);

//                             Navigator.pop(context);
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
