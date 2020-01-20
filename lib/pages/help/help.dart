import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HelpState();
  }
}

class _HelpState extends State<Help>{
  final _key = UniqueKey();
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Set<JavascriptChannel> jsChannels = [
      JavascriptChannel(
          name: 'Android',
          onMessageReceived: (JavascriptMessage message) {
            //handl
            // e message here
            print('Goooooot'+message.message);
            if(message.message.toString() == 'Help'){
              Navigator.of(context).pop();
            }
          }),
    ].toSet();
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: SafeArea(child: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: < Widget > [
                Expanded(
                    child: WebView(

                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: _webLink(),
                      onPageFinished: _handleLoad,
                      javascriptChannels: jsChannels,
                    )
                ),
              ],
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ))
    );
  }

  _webLink() {
    if(UserPreferenceUtil.displayLanguageTypeEnum == DisplayLanguageTypeEnum.English ){
      return 'https://help.bagayar.club';
    }else{
      return 'https://helpmm.bagayar.club';
    }
  }
}
