import 'package:flutter/material.dart';
import 'package:tolymoly/pages/buy/buy_ad_list.dart';

class HomeHeader extends StatelessWidget {
  final String headerText;
  final String navigationText;
  final route;
  HomeHeader(this.headerText)
      : this.navigationText = null,
        this.route = null;
  HomeHeader.withMore(this.headerText, this.navigationText, this.route);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Text(
              headerText,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
            ),
          ),
          if (navigationText != null)
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => route),
              ),
              child: Text(
                navigationText,
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            )
        ],
      ),
    );
    // return Padding(
    //     padding: EdgeInsets.all(12),
    //     child: Align(
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           text,
    //           style: TextStyle(
    //               fontSize: 22,
    //               color: Colors.black,
    //               fontWeight: FontWeight.bold),
    //         )));
  }
}
