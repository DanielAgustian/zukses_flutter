import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/register/choice-box.dart';
import 'package:zukses_app_1/constant/constant.dart';

class QuestionFormat extends StatelessWidget {
  const QuestionFormat(
      {Key key,
      this.question,
      this.answer1,
      this.answer2,
      this.bool1,
      this.bool2,
      this.click1,
      this.click2,
      @required this.size})
      : super(key: key);

  final String question, answer1, answer2;
  final bool bool1, bool2;
  final Size size;
  final Function click1, click2;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
                color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
          ),
          SizedBox(
            height: 10,
          ),
          ChoiceBox(
            choice1: bool1,
            choice2: bool2,
            onClick1: click1,
            onClick2: click2,
            size: size,
            answer: answer1,
            answer2: answer2,
          )
        ],
      ),
    );
  }
}
class QuestionFormat2 extends StatelessWidget {
  const QuestionFormat2(
      {Key key,
      this.question,
      this.answer1,
      this.answer2,
      this.bool1,
      this.bool2,
      this.click1,
      this.click2,
      @required this.size})
      : super(key: key);

  final String question, answer1, answer2;
  final bool bool1, bool2;
  final Size size;
  final Function click1, click2;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
                color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
          ),
          SizedBox(
            height: 10,
          ),
          ChoiceBox2(
            choice1: bool1,
            choice2: bool2,
            onClick1: click1,
            onClick2: click2,
            size: size,
            answer: answer1,
            answer2: answer2,
          )
        ],
      ),
    );
  }
}
