// import 'package:flutter/material.dart';
// import 'package:tolymoly/dto/location_picker_dto.dart';
// import 'package:tolymoly/models/region.dart';
// import 'package:tolymoly/models/township.dart';
// import 'package:tolymoly/repositories/region_repository.dart';
// import 'package:tolymoly/repositories/township_repository.dart';

// class BuyLocationPicker extends StatefulWidget {
//   final Function locationCallback;
//   BuyLocationPicker(this.locationCallback);
//   @override
//   _BuyLocationPickerState createState() => _BuyLocationPickerState();
// }

// class _BuyLocationPickerState extends State<BuyLocationPicker> {
//   // int currentCategoryId = 0;
//   int currentRegionId = 0;
//   String currentRegionName;
//   String textArrow = '<';
//   String textChoose = 'Choose';
//   String previousButtonText = '';
//   List previousId = [0];
//   bool isRegion = true;
//   String title = 'Region';

//   @override
//   void initState() {
//     previousButtonText = textChoose;
//     super.initState();
//   }

//   Future<List<Region>> _getRegion() async {
//     print('_getRegion');
//     return await RegionRepository.find();
//   }

//   Future<List<Township>> _getTownship() async {
//     print('_getTownship');
//     List<Township> townships = await TownshipRepository.find(currentRegionId);
//     townships.insert(0, Township(0, '~ All ~', currentRegionId));
//     return townships;
//   }

//   void _selectRegion(int regionId, String regionName) async {
//     isRegion = false;
//     currentRegionId = regionId;
//     currentRegionName = regionName;
//     title = 'Township';

//     // this.currentParentId = categoryId;
//     // previousId.add(categoryId);
//     previousButtonText = textArrow;
//     setState(() {});
//   }

//   void _back() {
//     previousButtonText = textChoose;

//     if (isRegion) return;

//     isRegion = true;
//     title = 'Region';

//     setState(() {});
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
//                       int id = snapshot.data[index].id;
//                       String name = snapshot.data[index].name;
//                       return ListTile(
//                         title: Text(name),
//                         trailing:
//                             isRegion ? Icon(Icons.keyboard_arrow_right) : null,
//                         onTap: () {
//                           if (isRegion) {
//                             _selectRegion(id, name);
//                           } else {
//                             LocationPickerDto dto = new LocationPickerDto();
//                             dto.townshipId = id;
//                             dto.townshipName = name;
//                             dto.regionId = currentRegionId;
//                             dto.regionName = currentRegionName;
//                             widget.locationCallback(dto);
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
