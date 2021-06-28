import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/send-feedback/text-row.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenAnswerContact extends StatefulWidget {
  ScreenAnswerContact();
  _ScreenAnswerContact createState() => _ScreenAnswerContact();
}

class _ScreenAnswerContact extends State<ScreenAnswerContact> {
  final textMessage = TextEditingController();
  bool response = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Contact Supervisor",
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 600 ? 20 : 22)),
        backgroundColor: colorBackground,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: colorPrimary,
              ))),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextRowSendFeedback(
                title: "Status",
                textItem: "pending",
                fontSize: size.height < 569 ? 14 : 16,
              ),
              SizedBox(
                height: 15,
              ),
              TextRowSendFeedback(
                title: "Detail",
                textItem: "24 Januari 2021",
                fontSize: size.height < 569 ? 14 : 16,
              ),
              Container(
                width: size.width,
                alignment: Alignment.centerRight,
                child: Text("13:00",
                    style: TextStyle(
                        fontSize: size.height < 569 ? 14 : 16,
                        color: colorGoogle,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Message",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eget elementum malesuada elit ultrices duis. Eros, mi elementum aliquam mauris. Justo integer magna hendrerit euismod.",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16, color: colorPrimary),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Answer",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eget elementum malesuada elit ultrices duis. Eros, mi elementum aliquam mauris. Justo integer magna hendrerit euismod.",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16, color: colorPrimary),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerRight,
                width: size.width,
                child: SmallButton(
                  onClick: () {
                    setState(() {
                      response = !response;
                    });
                    print('Response Clicked' + response.toString());
                  },
                  title: "Response",
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              response
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Write Your Message Here",
                          style: TextStyle(
                              fontSize: size.height < 569 ? 14 : 16,
                              color: colorGoogle,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: colorBackground,
                              boxShadow: [
                                BoxShadow(
                                  color: colorNeutral1.withOpacity(1),
                                  blurRadius: 15,
                                )
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            readOnly: true,
                            maxLines: 8,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textMessage,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                hintText: /*"apply_overtime_text5".tr()*/ "Tell the question you want to ask",
                                hintStyle: TextStyle(
                                  color: colorNeutral1,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: size.width,
                          child: SmallButton(
                            onClick: () {},
                            title: "Save",
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
