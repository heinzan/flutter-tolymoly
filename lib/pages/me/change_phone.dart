import 'package:flutter/material.dart';

class ChangePhone extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios , color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Change Phone",
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20.0),
            child:   OutlineButton(
              borderSide: BorderSide(width: 1.0 ),
                child: Text("Change phone by SMS"),
                onPressed: (){

                },

            ) ,
          ),

        ],
      )


    );
  }

}