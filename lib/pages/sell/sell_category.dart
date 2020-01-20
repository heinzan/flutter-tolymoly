// import 'package:flutter/material.dart';
// import 'package:tolymoly/dto/category_picker_dto.dart';
// import 'package:tolymoly/models/category.dart';
// import 'package:tolymoly/pages/sell/sell_form.dart';
// import 'package:tolymoly/repositories/category_repository.dart';

// class SellCategory extends StatefulWidget {
//   @override
//   _SellCategoryState createState() => _SellCategoryState();
// }

// class _SellCategoryState extends State<SellCategory> {
//   // int currentCategoryId = 0;
//   int currentParentId = 0;
//   String textArrow = '<';
//   String textChoose = 'Choose';
//   String previousButtonText = '';
//   List previousId = [0];

//   Future<List<Category>> _getCategories() async {
//     print('_getCategories');
//     return await CategoryRepository.find(currentParentId);
//   }

//   void _selectCategory(int categoryId) async {
//     this.currentParentId = categoryId;
//     previousId.add(categoryId);
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
//   void initState() {
//     previousButtonText = textChoose;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Category'),
//         // actions: <Widget>[
//         //   // test button
//         //   IconButton(
//         //     icon: Icon(Icons.directions_car),
//         //     onPressed: () {
//         //       var data = {'categoryId': 3, 'categoryName': 0, 'adId': 49};
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(builder: (context) => SellForm(data: data)),
//         //       );
//         //       // Navigator.pushNamed(context, "/sell/sell_category");
//         //     },
//         //   ),
//         // ],
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
//                       return ListTile(
//                         title: Text(snapshot.data[index].name),
//                         trailing: snapshot.data[index].hasChild
//                             ? Icon(Icons.keyboard_arrow_right)
//                             : null,
//                         onTap: () {
//                           if (snapshot.data[index].hasChild) {
//                             _selectCategory(snapshot.data[index].id);
//                           } else {
//                             var data = {
//                               'categoryId': snapshot.data[index].id,
//                               'categoryName': snapshot.data[index].name,
//                               'isNew': true
//                             };
//                             CategoryPickerDto dto = new CategoryPickerDto();
//                             dto.id = snapshot.data[index].id;
//                             dto.id = snapshot.data[index].name;
//                             dto.isNewAd = true;
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         new SellForm.fromCategory(dto)));
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
//   // @override
//   // Widget build(BuildContext context) {
//   //   return new Scaffold(
//   //     appBar: new AppBar(
//   //       title: new Text('Category'),
//   //     ),
//   //     body: Container(
//   //       child: FutureBuilder(
//   //         future: _getCategories(),
//   //         builder: (BuildContext context, AsyncSnapshot snapshot) {
//   //           print('snapshot.data...');
//   //           print(snapshot.data);
//   //           if (snapshot.data == null) {
//   //             return Container(child: Center(child: Text("Loading...")));
//   //           } else {
//   //             return ListView.builder(
//   //               itemCount: snapshot.data.length,
//   //               itemBuilder: (BuildContext context, int index) {
//   //                 return ListTile(
//   //                   title: Text(snapshot.data[index].name),
//   //                   onTap: () {
//   //                     // parentId = snapshot.data[index].id;
//   //                     _selectCategory(snapshot.data[index].id);
//   //                     // setState(() {});
//   //                   },
//   //                 );
//   //               },
//   //             );
//   //           }
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }
// }
