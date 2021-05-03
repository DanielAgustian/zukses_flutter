import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/pricing-model.dart';

class PricingCard extends StatelessWidget {
  const PricingCard({Key key, @required this.size, this.onClick, this.price})
      : super(key: key);

  final Size size;
  final Function onClick;
  final PricingModel price;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width,
      height: 475,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            price.planName,
            style: TextStyle(
                fontSize: size.height < 569 ? 16 : 20,
                color: colorBackground,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height < 569 ? 5 : 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Rp" + price.price.toString(),
                  style: TextStyle(
                      fontSize: size.height < 569 ? 16 : 20,
                      color: colorBackground,
                      fontWeight: FontWeight.bold)),
              Text("/" + price.interval,
                  style: TextStyle(
                      fontSize: size.height < 569 ? 10 : 12,
                      color: colorBackground)),
            ],
          ),
          SizedBox(height: size.height < 569 ? 5 : 10),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _pricingCardChild(context, size, "Clock in & out", true),
              _pricingCardChild(context, size, "Attendance", true),
              _pricingCardChild(context, size, "Task management", true),
              _pricingCardChild2(
                  context, size, "Project Limit", price.projectLimit),
              _pricingCardChild(context, size, "Project Role", true),
              _pricingCardChild(context, size, "Meeting Scheduling", true),
              _pricingCardChild(context, size, "Meeting Role Assign", true)
            ],
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: onClick,
              child: Container(
                width: size.height < 569 ? 100 : 120,
                height: size.height < 569 ? 40 : 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorBackground),
                child: Center(
                  child: Text(
                    "Choose Plan",
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 13 : 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _pricingCardChild(
      BuildContext context, Size size, String title, bool value) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorBackground, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14, color: colorBackground),
          ),
          FaIcon(
            value
                ? FontAwesomeIcons.solidCheckCircle
                : FontAwesomeIcons.timesCircle,
            color: colorBackground,
            size: size.height < 569 ? 14 : 18,
          )
        ],
      ),
    );
  }

  Widget _pricingCardChild2(
      BuildContext context, Size size, String title, String total) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorBackground, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14, color: colorBackground),
          ),
          Text(
            total,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14,
                color: colorBackground,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class PricingCard2 extends StatelessWidget {
  const PricingCard2({Key key, @required this.size, this.onClick, this.price})
      : super(key: key);

  final Size size;
  final Function onClick;
  final PricingModel price;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width,
      height: size.height < 569 ? 400 : 475,
      decoration: BoxDecoration(
        color: colorBackground,
        border: Border.all(width: 1, color: colorPrimary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            price.planName,
            style: TextStyle(
                fontSize: size.height < 569 ? 16 : 20,
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height < 569 ? 5 : 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Rp " + price.price.toString(),
                  style: TextStyle(
                      fontSize: size.height < 569 ? 16 : 20,
                      color: colorPrimary,
                      fontWeight: FontWeight.bold)),
              Text("/" + price.interval,
                  style: TextStyle(
                      fontSize: size.height < 569 ? 10 : 12,
                      color: colorPrimary)),
            ],
          ),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _pricingCardChild(context, size, "Clock in & out", false),
              _pricingCardChild(context, size, "Attendance", false),
              _pricingCardChild(context, size, "Task management", true),
              _pricingCardChild2(
                  context, size, "Project Limit", price.projectLimit),
              _pricingCardChild(context, size, "Project Role", false),
              _pricingCardChild(context, size, "Meeting Scheduling", true),
              _pricingCardChild(context, size, "Meeting Role Assign", false)
            ],
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: onClick,
              child: Container(
                width: size.height < 569 ? 100 : 120,
                height: size.height < 569 ? 40 : 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorPrimary),
                child: Center(
                  child: Text(
                    "Choose Plan",
                    style: TextStyle(
                        color: colorBackground,
                        fontSize: size.height < 569 ? 13 : 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _pricingCardChild(
      BuildContext context, Size size, String title, bool value) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorPrimary, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14, color: colorPrimary),
          ),
          FaIcon(
              value
                  ? FontAwesomeIcons.solidCheckCircle
                  : FontAwesomeIcons.timesCircle,
              color: value ? colorPrimary : colorNeutral2,
              size: size.height < 569 ? 14 : 18)
        ],
      ),
    );
  }

  Widget _pricingCardChild2(
      BuildContext context, Size size, String title, String total) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorPrimary, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14, color: colorPrimary),
          ),
          Text(
            total,
            style: TextStyle(
                fontSize: size.height < 569 ? 10 : 14,
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
