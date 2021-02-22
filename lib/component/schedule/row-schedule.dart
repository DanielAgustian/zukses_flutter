import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AddScheduleRow extends StatelessWidget {
  const AddScheduleRow({
    Key key,
    this.title,
    this.textItem,
  }) : super(key: key);

  final String title, textItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: colorPrimary),
          ),
          Row(
            children: [
              Text(
                textItem,
                style: TextStyle(
                    fontSize: 16,
                    color: colorPrimary,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 10,
              ),
              title != "Time"
                  ? FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: colorPrimary,
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
