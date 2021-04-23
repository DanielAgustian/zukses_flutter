import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TaskRow extends StatelessWidget {
  const TaskRow({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          DropdownButton(
            value: textItem,
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 18,
              color: colorPrimary,
            ),
            elevation: 16,
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
            underline: Container(),
            onChanged: (String newValue) {
              onSelectedItem(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class TaskRow2 extends StatelessWidget {
  const TaskRow2({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          DropdownButton(
            value: textItem,
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              color: colorPrimary,
              size: 18,
            ),
            elevation: 16,
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
            underline: Container(),
            onChanged: (String newValue) {
              onSelectedItem(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: colorPrimary,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 5),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: colorChange(value),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.chevronUp,
                                      color: colorBackground,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Color colorChange(String priority) {
    if (priority == "High") {
      return colorError;
    } else if (priority == "Medium") {
      return colorSecondaryRed;
    } else {
      return colorSecondaryYellow;
    }
  }
}

class TaskRowLabel extends StatelessWidget {
  const TaskRowLabel({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          DropdownButton(
            value: textItem,
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              color: colorPrimary,
              size: 18,
            ),
            elevation: 16,
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
            underline: Container(),
            onChanged: (String newValue) {
              onSelectedItem(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: colorChange(value),
                          borderRadius: BorderRadius.circular(5)),
                      width: 90,
                      height: 30,
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: colorBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Color colorChange(String label) {
    if (label == "Front End") {
      return colorSecondaryYellow;
    } else if (label == "Back End") {
      return colorClear;
    } else if (label == "Design") {
      return colorSecondaryRed;
    } else {
      return colorError;
    }
  }
}

class RowTaskUndroppable extends StatelessWidget {
  const RowTaskUndroppable(
      {Key key,
      this.title,
      this.textItem,
      this.fontSize: 16,
      this.priority = false,
      this.needArrow = false})
      : super(key: key);

  final String title, textItem;
  final double fontSize;
  final bool needArrow;
  final bool priority;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                textItem,
                style: TextStyle(
                    fontSize: fontSize,
                    color: colorPrimary,
                    fontWeight: FontWeight.w700),
              ),
              priority
                  ? SizedBox(
                      width: 10,
                    )
                  : Container(),
              priority
                  ? Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          color: colorChange(textItem),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.chevronUp,
                          color: colorBackground,
                          size: 15,
                        ),
                      ),
                    )
                  : Container() /*FaIcon(FontAwesomeIcons.chevronDown,
                      size: 18,
                      color: needArrow ? colorPrimary : Colors.transparent)*/
            ],
          )
        ],
      ),
    );
  }

  Color colorChange(String label) {
    if (label == "Front End") {
      return colorSecondaryYellow;
    } else if (label == "Back End") {
      return colorClear;
    } else if (label == "Design") {
      return colorSecondaryRed;
    } else {
      return colorError;
    }
  }
}

class RowTaskDrop extends StatelessWidget {
  const RowTaskDrop(
      {Key key,
      this.textItem,
      this.fontSize: 16,
      this.size,
      @required this.list,
      this.onSelectedItem})
      : super(key: key);

  final String textItem;
  final double fontSize;
  final Size size;
  final List<String> list;
  final Function onSelectedItem;
  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        width: size.width,
        decoration: BoxDecoration(
          color: colorBackground,
          boxShadow: [boxShadowStandard],
          borderRadius: BorderRadius.circular(5),
        ),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                labelStyle: TextStyle(fontSize: 12),
                errorStyle: TextStyle(color: colorError, fontSize: 16.0),
                hintText: "",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                /*border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))*/
              ),
              isEmpty: textItem == '',
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: textItem,
                    isDense: true,
                    onChanged: onSelectedItem,
                    items: list.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
