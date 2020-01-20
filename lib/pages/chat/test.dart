import 'package:flutter/material.dart';
import 'package:tolymoly/api/chat_api.dart';
import 'package:oktoast/oktoast.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final _formKey = GlobalKey<FormState>();
  final adIdController = TextEditingController(text: "1");
  final receiverIdController = TextEditingController(text: "1");
  final messageController = TextEditingController(text: "test 123");

  _saveMessage() {
    print("save:" + adIdController.text);
    int adId = int.parse(adIdController.text);
    int receiverId = int.parse(adIdController.text);
    String message = messageController.text;
    ChatApi.post({"adId": adId, "receiverId": receiverId, "message": message})
        .then((response) {
      print('response...');
      print(response.data);
      print(response.statusCode);

      // final int statusCode = response.statusCode;
      // if (statusCode == 200) {
      //   print(json.decode(response.body));
      // }
    });
  }

  _toast() {
    print('toast...');
    // showToast('Hello FilledStacks', position: ToastPosition.bottom);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text('Test send message')),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'AD id'),
                controller: adIdController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Receiver id'),
                controller: receiverIdController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                controller: messageController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      _toast();
                      _saveMessage();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
