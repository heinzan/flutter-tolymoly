import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolymoly/constants/asset_path_constant.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/pages/favourite/favourite.dart';
import 'package:tolymoly/pages/me/profile.dart';
import 'package:tolymoly/pages/me/my_ads.dart';
import 'package:tolymoly/pages/home/home_language.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'contact_us.dart';
import 'package:tolymoly/pages/help/help.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  UserService userService = new UserService();
  var userData;

  @override
  Widget build(BuildContext context) {
    print('Me > build...');

    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: AuthUtil.isLoggedIn ? userService.find() : _getUnregisterUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            print('no data...');
            return Container(child: Center(child: Text("Loading...")));
          } else {
            return list(snapshot);
          }
        },
      ),
    ));
  }

  Widget list(AsyncSnapshot snapshot) {
    return new ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 70.0,
              decoration: BoxDecoration(
                  color: const Color(0xFF0E3311).withOpacity(0.5),
                  image: DecorationImage(
                      image: AssetImage("assets/images/headerProfile.jpg"),
                      fit: BoxFit.fill)),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 28.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(),
                  GestureDetector(
                    onTap: () {
                      if (!AuthUtil.validate(context)) return;

                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new Profile()));
                    },
                    child: Container(
                      height: 75.0,
                      width: 75.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: snapshot.data.image == null
                                ? AssetImage(AssetPathConstant.defaultUserImage)
                                // : NetworkImage(snapshot.data.image),
                                : CachedNetworkImageProvider(
                                    snapshot.data.image),
                          )),
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
        Container(
          child: Column(
            children: <Widget>[
              Text(
                snapshot.data.username,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              getConfirm(snapshot.data),
              getJoinDate(snapshot.data),
            ],
          ),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/icons/shopping_cart_outline.svg',
            color: Colors.green,
            width: 34,
            height: 34,
          ),
          title: Text(LocaleUtil.get('My Ads')),
          onTap: () {
            if (!AuthUtil.validate(context)) return;

            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return MyAds();
            }));
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Divider(
            color: Colors.black26,
            height: 0.5,
          ),
        ),
        ListTile(
          onTap: () {
            if (!AuthUtil.validate(context)) return;

            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return Favourite();
            }));
          },
          leading: Icon(
            Icons.favorite_border,
            color: Colors.pinkAccent,
            size: 34,
          ),
          title: Text(LocaleUtil.get('Favourites')),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Divider(
            color: Colors.black26,
            height: 0.5,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return Help();
            }));
          },
          leading: Icon(
            Icons.help_outline,
            color: ColorConstant.primary,
            size: 34,
          ),
          title: Text(LocaleUtil.get('Help')),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Divider(
            color: Colors.black26,
            height: 0.5,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return ContactUs();
            }));
          },
          leading: Icon(
            Icons.phone,
            color: Colors.blue,
            size: 34,
          ),
          title: Text(LocaleUtil.get('Contactus')),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Divider(
            color: Colors.black26,
            height: 0.5,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return HomeLanguage();
            }));
          },
          leading: Icon(
            Icons.language,
            color: Colors.black38,
            size: 34,
          ),
          title: Text(LocaleUtil.get('Language')),
        ),
      ],
    );
  }

  Widget getConfirm(snapshotData) {
    if (snapshotData.isRegisteredByFacebook) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(LocaleUtil.get('Confirmed')),
          Image.asset('assets/icons/facebook.png', height: 20.0)
        ],
      );
    } else {
      return SizedBox.shrink();
    }

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     Text(LocaleUtil.get('Confirmed')),
    //     CircleAvatar(
    //       maxRadius: 10.0,
    //       backgroundColor: Colors.orange[800],
    //       child: Icon(
    //         Icons.phone_android,
    //         color: Colors.white,
    //         size: 15.0,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget getJoinDate(snapshotData) {
    if (snapshotData.joinedDate == null) return SizedBox.shrink();
    // String joinDate =
    //     // DateFormat.yMMMMd("en_US").format(snapshotData.updatedDate);
    //     DateFormat.yMMMMd("en_US").format(snapshotData.joinedDate);
    String joinLangStr = LocaleUtil.get('Joined');
    return Text("$joinLangStr ${snapshotData.joinedDate}");
  }

  Future<UserModel> _getUnregisterUser() {
    UserModel user = new UserModel();
    if (!AuthUtil.isLoggedIn) {
      user.username = LocaleUtil.get('Please register');
      user.isRegisteredByFacebook = false;
      user.isRegisteredBySms = false;
    }
    return Future<UserModel>.value(user);
  }
}
