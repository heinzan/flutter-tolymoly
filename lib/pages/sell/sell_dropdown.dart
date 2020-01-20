import 'package:flutter/material.dart';
import 'package:tolymoly/dto/reference_dto.dart';
import 'package:tolymoly/repositories/reference_repository.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class SellDropdown2 extends StatefulWidget {
  final bool isRequired;
  final String attributeName;
  final String labelName;
  final Function conditionCallback;
  final TextEditingController textEditingController;
  final List<ReferenceDto> referenceDtos;

  SellDropdown2(this.isRequired, this.attributeName, this.labelName,
      this.conditionCallback, this.textEditingController, this.referenceDtos);
  _SellDropdown2State createState() => _SellDropdown2State();
}

class _SellDropdown2State extends State<SellDropdown2> {
  @override
  Widget build(BuildContext context) {
    String label = widget.labelName;
    if (widget.isRequired) label = '* $label';

    return GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(widget.labelName),
                  content: Container(
                    width: double.maxFinite,
                    // height: 300.0,
                    child: Scrollbar(
                        child: ListView.builder(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.referenceDtos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(widget.referenceDtos[index].name),
                          onTap: () {
                            widget.conditionCallback(
                                widget.attributeName,
                                widget.referenceDtos[index].id,
                                widget.referenceDtos[index].name);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    )),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: AbsorbPointer(
            child: TextFormField(
          controller: widget.textEditingController,
          decoration: InputDecoration(labelText: label),
          validator: (value) {
            if (widget.isRequired && value.isEmpty) {
              return LocaleUtil.get("Please enter");
            }
            return null;
          },
        )));
  }
}
