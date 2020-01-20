import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oktoast/oktoast.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactUsState();
  }
}

class _ContactUsState extends State<ContactUs> {
  List<Map<String, String>> installedApps;
  List<Map<String, String>> iOSApps = [
    {"app_name": "Messenger", "package_name": "com.facebook.orca"},
    {"app_name": "Facebook", "package_name": "com.facebook.katana"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocaleUtil.get('Contactus'),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
        backgroundColor: ColorConstant.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        onTap: () {
                          _openFacebookMessenger();
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset("assets/icons/facebook_messenger.png"),
                            Padding(padding: EdgeInsets.only(left: 8.0)),
                            Text('Facebook Messenger')
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.black26,
                        height: 0.5,
                      ),
                    ),
                    ListTile(
                        onTap: () {
                          _openFacebook();
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset("assets/icons/facebook.png"),
                            Padding(padding: EdgeInsets.only(left: 8.0)),
                            Text('Facebook')
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8.0 , left: 22.0) ,
              child:  Text(
                LocaleUtil.get('Phone'),
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),),

              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        onTap: () {
                          launch('tel:09967611168');
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: Colors.orange,
                            ),
                            Padding(padding: EdgeInsets.only(left: 8.0)),
                            Text('09967611168')
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Divider(
                        color: Colors.black26,
                        height: 0.5,
                      ),
                    ),
                    ListTile(
                        onTap: () {
                          launch("tel:09951203008");
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: Colors.orange,
                            ),
                            Padding(padding: EdgeInsets.only(left: 8.0)),
                            Text('09951203008')
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFacebook() async {
    const url = 'https://fb.me/tolymoly.myanmar/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url');
    }
  }

  void _openFacebookMessenger() async {
    const url = 'https://m.me/tolymoly.myanmar/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url');
    }
  }
}
