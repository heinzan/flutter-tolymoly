import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/pages/auth/auth_login.dart';

class AuthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: ColorConstant.primary,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: TabBar(
              tabs: [Tab(text: 'Register'), Tab(text: 'Login')],
            ),
            title: Text('Welcome'),
          ),
          body: TabBarView(
            children: [
              AuthLogin.register(),
              AuthLogin.login(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget login() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Column(children: <Widget>[],),
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           automaticallyImplyLeading: true,
  //           leading: IconButton(
  //             icon: Icon(Icons.arrow_back),
  //             onPressed: () => Navigator.pop(context, false),
  //           ),
  //           bottom: TabBar(
  //             tabs: [Tab(text: 'Registration'), Tab(text: 'Login')],
  //           ),
  //           title: Text('Welcome'),
  //         ),
  //         body: TabBarView(
  //           children: [
  //             Login(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
