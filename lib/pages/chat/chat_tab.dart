import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/pages/chat/chat_list.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: ColorConstant.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleUtil.get('All')),
              Tab(text: LocaleUtil.get('Buying')),
              Tab(text: LocaleUtil.get('Selling'))
            ],
          ),
          title: Text(LocaleUtil.get('Chat')),
        ),
        body: TabBarView(
          children: [
            ChatList.all(),
            ChatList.buying(),
            ChatList.selling(),
          ],
        ),
      ),
    );
  }
}
