import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class ChoiceBox extends StatelessWidget {
  const ChoiceBox(
      {Key key,
      this.answer,
      this.answer2,
      this.choice1,
      this.choice2,
      this.onClick1,
      this.onClick2,
      @required this.size})
      : super(key: key);

  final String answer, answer2;
  final bool choice1, choice2;
  final Size size;
  final Function onClick1, onClick2;
  @override
  Widget build(BuildContext context) {
    bool pilihan1 = choice1;
    bool pilihan2 = choice2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            pilihan1 = true;
            if (pilihan1 == true && pilihan2 == true) {
              pilihan2 = !pilihan2;
            }
            print("pilihan1 = " + pilihan1.toString());
            onClick1(pilihan1);
          },
          child: Container(
            width: 0.42 * size.width,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: colorPrimary),
                borderRadius: BorderRadius.circular(5),
                color: pilihan1 ? colorPrimary30 : colorBackground),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    answer,
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 10 : 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                pilihan1
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: colorPrimary,
                            size: 10,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            pilihan2 = true;
            if (pilihan1 == true && pilihan2 == true) {
              pilihan1 = !pilihan1;
            }
            print("Pilihan2 = " + pilihan2.toString());
            onClick2(pilihan2);
          },
          child: Container(
            width: 0.42 * size.width,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: colorPrimary),
                borderRadius: BorderRadius.circular(5),
                color: pilihan2 ? colorPrimary30 : colorBackground),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    answer2,
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 10 : 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                pilihan2
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: colorPrimary,
                            size: 10,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChoiceBox2 extends StatelessWidget {
  const ChoiceBox2(
      {Key key,
      this.answer,
      this.answer2,
      this.choice1,
      this.choice2,
      this.onClick1,
      this.onClick2,
      @required this.size})
      : super(key: key);

  final String answer, answer2;
  final bool choice1, choice2;
  final Size size;
  final Function onClick1, onClick2;
  @override
  Widget build(BuildContext context) {
    bool pilihan1 = choice1;
    bool pilihan2 = choice2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            pilihan1 = true;
            if (pilihan1 == true && pilihan2 == true) {
              pilihan2 = !pilihan2;
            }
            print("pilihan1 = " + pilihan1.toString());
            onClick1(pilihan1);
          },
          child: Container(
            width: 0.9 * size.width,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: colorPrimary),
                borderRadius: BorderRadius.circular(5),
                color: pilihan1 ? colorPrimary30 : colorBackground),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    answer,
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 10 : 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                pilihan1
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: colorPrimary,
                            size: 10,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        InkWell(
          onTap: () {
            pilihan2 = true;
            if (pilihan1 == true && pilihan2 == true) {
              pilihan1 = !pilihan1;
            }
            print("Pilihan2 = " + pilihan2.toString());
            onClick2(pilihan2);
          },
          child: Container(
            width: 0.9 * size.width,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: colorPrimary),
                borderRadius: BorderRadius.circular(5),
                color: pilihan2 ? colorPrimary30 : colorBackground),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    answer2,
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 10 : 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                pilihan2
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: colorPrimary,
                            size: 10,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
