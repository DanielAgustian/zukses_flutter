import 'package:flutter/material.dart';

import 'package:zukses_app_1/constant/constant.dart';

class TextBoxSetup extends StatelessWidget {
  const TextBoxSetup(
      {Key key,
      this.question,
      this.hint,
      this.onChanged,
      @required this.textBox,
      @required this.size})
      : super(key: key);

  final String question, hint;
  final Size size;
  final TextEditingController textBox;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
                color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorBorder),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  onChanged(val);
                },
                controller: textBox,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: colorNeutral1,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              )),
        ],
      ),
    );
  }
}

class TextDropDownSetup extends StatelessWidget {
  const TextDropDownSetup(
      {Key key,
      this.question,
      this.hint,
      this.textItem,
      this.data,
      this.onChanged,
      @required this.size})
      : super(key: key);

  final String question, hint;
  final Size size;
  final String textItem;
  final List<String> data;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
                color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorBorder),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 12),
                        errorStyle:
                            TextStyle(color: colorError, fontSize: 16.0),
                        hintText: 'Please select your role',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: textItem == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: textItem,
                        isDense: true,
                        onChanged: (String newValue) {
                          onChanged(newValue);
                        },
                        items: data.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
