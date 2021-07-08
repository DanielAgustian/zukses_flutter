import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/model/admin-model.dart';
import 'package:zukses_app_1/model/message-type-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-answer-contact.dart';

class ScreenContactSupervisor extends StatefulWidget {
  ScreenContactSupervisor({this.model});
  final model;
  _ScreenContactSupervisor createState() => _ScreenContactSupervisor();
}

class _ScreenContactSupervisor extends State<ScreenContactSupervisor> {
  final textMessage = TextEditingController();

  MessageTypeModel messageItem = MessageTypeModel();
  AdminModel admin = AdminModel();
  bool emptyMessage = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAdminBloc>(context).add(GetAdminAllEvent());
    BlocProvider.of<MessageTypeBloc>(context).add(GetMessageTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenAnswerContact()));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
        title: Text(
          "contact_spv_1".tr(),
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 22),
        ),
        actions: [],
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
              SizedBox(
                height: 10,
              ),
              Text(
                "contact_spv_2".tr(),
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
                    border: Border.all(
                        color: emptyMessage ? colorError : Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 15,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textMessage,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "contact_spv_3".tr(),
                      hintStyle: TextStyle(
                        color: colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "contact_spv_4".tr(),
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              dropdownMessageType(context, size),
              SizedBox(
                height: 20,
              ),
              Text(
                "contact_spv_5".tr(),
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              dropdownAdmin(context, size),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerRight,
                width: size.width,
                child: SmallButton(
                  onClick: () {
                    sentData();
                  },
                  title: "contact_spv_6".tr(),
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropdownMessageType(BuildContext context, Size size) {
    return BlocBuilder<MessageTypeBloc, MessageTypeState>(
        builder: (context, state) {
      if (state is MessageTypeStateSuccess) {
        MessageTypeModel modelFirst = state.models[0];
        List<MessageTypeModel> models = state.models;

        return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              color: colorBackground,
              boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 15,
                )
              ],
            ),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 12),
                    errorStyle: TextStyle(color: colorError, fontSize: 16.0),
                    hintText: 'company_text8'.tr(),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                  ),
                  isEmpty: false,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<MessageTypeModel>(
                      value: modelFirst,
                      isDense: true,
                      onChanged: (MessageTypeModel newValue) {
                        setState(() {
                          modelFirst = newValue;
                          messageItem = modelFirst;
                        });
                      },
                      items: models.map((MessageTypeModel value) {
                        return DropdownMenuItem<MessageTypeModel>(
                          value: value,
                          child: Text(value.type),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ));
      }

      return Container(
        width: size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget dropdownAdmin(BuildContext context, Size size) {
    return BlocBuilder<GetAdminBloc, GetAdminState>(builder: (context, state) {
      if (state is GetAdminStateSuccess) {
        AdminModel modelFirst = state.model[0];
        List<AdminModel> models = state.model;
        return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              color: colorBackground,
              boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 15,
                )
              ],
            ),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 12),
                    errorStyle: TextStyle(color: colorError, fontSize: 16.0),
                    hintText: 'company_text8'.tr(),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                  ),
                  isEmpty: false,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AdminModel>(
                      value: modelFirst,
                      isDense: true,
                      onChanged: (AdminModel newValue) {
                        setState(() {
                          modelFirst = newValue;
                          admin = modelFirst;
                        });
                      },
                      items: models.map((AdminModel value) {
                        return DropdownMenuItem<AdminModel>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ));
      }

      return Container(
        width: size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  void sentData() {
    if (textMessage.text != "") {
      setState(() {
        emptyMessage = false;
      });
    } else {
      setState(() {
        emptyMessage = true;
      });
    }

    if (!emptyMessage) {
      BlocProvider.of<ContactSupervisorBloc>(context).add(
          ContactSupervisorAddEvent(
              message: textMessage.text,
              receiverId: admin.id.toString(),
              typeId: messageItem.id.toString(),
              about: "others"));
    }
  }
}
