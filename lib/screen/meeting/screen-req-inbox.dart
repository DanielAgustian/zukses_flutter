import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/meeting/screen-tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestInbox extends StatefulWidget {
  @override
  _RequestInboxState createState() => _RequestInboxState();
}

class _RequestInboxState extends State<RequestInbox>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  bool isLoading = true;

  void timer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    timer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Request",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 569 ? 20 : 25,
              color: colorPrimary),
        ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: colorBackground,
          appBar: AppBar(
            backgroundColor: colorBackground,
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colorNeutral150,
                  borderRadius: BorderRadius.circular(5)),
              child: TabBar(
                controller: tabController,
                labelColor: colorBackground,
                unselectedLabelColor: colorPrimary,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicator: BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.circular(5)),
                tabs: [
                  Tab(
                    child: Container(
                      child: Center(
                        child: Text("Waiting"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Center(
                        child: Text("Accepted"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              ScreenTabRequest(
                loading: isLoading,
                screen: "wait",
              ),
              ScreenTabRequest(
                loading: isLoading,
                screen: "accept",
              )
            ],
          ),
        ),
      ),
    );
  }
}
