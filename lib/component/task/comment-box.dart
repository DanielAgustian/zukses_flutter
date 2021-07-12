import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class CommentBox extends StatelessWidget {
  CommentBox({
    Key key,
    this.user,
    this.comment,
    this.date,
    this.size,
  }) : super(key: key);

  final String user, comment;
  final String date;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration:
                    BoxDecoration(color: colorNeutral2, shape: BoxShape.circle),
              ),
              SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user,
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 20),
                      Text(date,
                          style: TextStyle(color: colorPrimary, fontSize: 12))
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                      width: size.width * 0.7,
                      child:
                          Text(comment, style: TextStyle(color: colorPrimary))),
                ],
              )
            ],
          ),
          InkWell(
              onTap: () {},
              child: FaIcon(FontAwesomeIcons.ellipsisV, size: 16)),
        ],
      ),
    );
  }
}

class HistoryBox extends StatelessWidget {
  HistoryBox({
    Key key,
    this.user,
    this.history,
    this.date,
    this.size,
  }) : super(key: key);
  final String user, history;
  final DateTime date;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
      child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: colorBackground,
              boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 15,
                )
              ],
              borderRadius: BorderRadius.circular(5)),
          child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: size.height < 569 ? 12 : 14,
                color: colorPrimary,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: user, style: TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(
                    text: ' has done ',
                    style: new TextStyle(color: colorGoogle)),
                new TextSpan(
                    text: history,
                    style: TextStyle(fontWeight: FontWeight.w400)),
                new TextSpan(
                    text: " at ", style: TextStyle(color: colorGoogle)),
                TextSpan(
                    text: Util().hourFormat(date) +
                        ", " +
                        Util().yearFormat(date))
              ],
            ),
          )),
    );
  }
}

class PostBox extends StatelessWidget {
  PostBox(
      {Key key,
      this.pp = true,
      this.hint = "Add a comment.. ",
      this.date,
      @required this.onPost,
      @required this.size,
      @required this.textEditController})
      : super(key: key);
  final String hint;
  final bool pp;
  final DateTime date;
  final Size size;
  final TextEditingController textEditController;
  final Function onPost;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 0.1 * size.width,
          height: 0.1 * size.width,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pp ? colorNeutral2 : colorBackground),
        ),
        Container(
          width: 0.77 * size.width,
          decoration: BoxDecoration(
            boxShadow: [boxShadowStandard],
            color: colorBackground,
            border: Border.all(width: 1, color: colorPrimary),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            onChanged: (val) {},
            controller: textEditController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 15),
                hintText: hint,
                hintStyle: TextStyle(
                  color: colorNeutral1,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: TextButton(
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: colorPrimary,
                          fontSize: size.height < 569 ? 14 : 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: onPost)),
          ),
        )
      ],
    );
  }
}

class AddCheckBox extends StatelessWidget {
  AddCheckBox(
      {Key key,
      @required this.onPost,
      @required this.size,
      @required this.textEditController})
      : super(key: key);

  final Size size;
  final TextEditingController textEditController;
  final Function onPost;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 0.1 * size.width,
          height: 0.1 * size.width,
          decoration:
              BoxDecoration(shape: BoxShape.rectangle, color: colorNeutral2),
        ),
        Container(
          width: 0.77 * size.width,
          decoration: BoxDecoration(
            boxShadow: [boxShadowStandard],
            color: colorBackground,
            border: Border.all(width: 1, color: colorPrimary),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            onChanged: (val) {},
            controller: textEditController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 15),
                hintText: "Add new list...",
                hintStyle: TextStyle(
                  color: colorNeutral1,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: TextButton(
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: colorPrimary,
                          fontSize: size.height < 569 ? 14 : 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: onPost)),
          ),
        )
      ],
    );
  }
}
