// import 'package:flutter/material.dart';
// import 'package:tolymoly/models/category.dart';
// import 'package:tolymoly/models/region_model.dart';
// import 'package:tolymoly/models/township_model.dart';
// import 'package:tolymoly/pages/sell/sell_form.dart';
// import 'package:tolymoly/repositories/category_repository.dart';
// import 'package:tolymoly/repositories/region_repository.dart';
// import 'package:tolymoly/repositories/township_repository.dart';

// class PropertyPicker extends StatefulWidget {
//   final Function propertyCallback;
//   PropertyPicker(this.propertyCallback);
//   @override
//   _PropertyPickerState createState() => _PropertyPickerState();
// }

// class _PropertyPickerState extends State<PropertyPicker> {
//   // int currentCategoryId = 0;
//   int currentRegionId = 0;
//   String textArrow = '<';
//   String textChoose = 'Choose';
//   String previousButtonText = '';
//   List previousId = [0];
//   bool isRegion = true;
//   String title = 'Region';

//   Future<List<RegionModel>> _getRegion() async {
//     print('_getRegion');
//     return await RegionRepository.find();
//   }

//   Future<List<TownshipModel>> _getTownship() async {
//     print('_getTownship');
//     return await TownshipRepository.find(currentRegionId);
//   }

//   void _selectRegion(int regionId) async {
//     isRegion = false;
//     currentRegionId = regionId;
//     title = 'Township';

//     // this.currentParentId = categoryId;
//     // previousId.add(categoryId);
//     previousButtonText = textArrow;
//     setState(() {});
//   }

//   void _back() {
//     if (isRegion) return;

//     isRegion = true;
//     title = 'Region';

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
//         title: new Text(title),
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
//                     _back();
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: isRegion ? _getRegion() : _getTownship(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 print('snapshot.data...');
//                 if (snapshot.data == null) {
//                   return Container(child: Center(child: Text("Loading...")));
//                 } else {
//                   return ListView.builder(
//                     // scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         title: Text(snapshot.data[index].townshipName),
//                         trailing:
//                             isRegion ? Icon(Icons.keyboard_arrow_right) : null,
//                         onTap: () {
//                           if (isRegion) {
//                             _selectRegion(snapshot.data[index].townshipId);
//                           } else {
//                             widget.propertyCallback(
//                                 snapshot.data[index].townshipName,
//                                 snapshot.data[index].townshipId);
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
