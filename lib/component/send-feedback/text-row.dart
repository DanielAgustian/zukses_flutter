import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';

class TextRowSendFeedback extends StatelessWidget {
  const TextRowSendFeedback({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
  }) : super(key: key);

  final String title;
  final String textItem;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: fontSize,
                color: colorGoogle,
                fontWeight: FontWeight.w700),
          ),
          Text(
            textItem,
            style: TextStyle(
              fontSize: fontSize,
              color: colorStatus(textItem),
            ),
          )
        ],
      ),
    );
  }

  Color colorStatus(String text) {
    if (text == "contact_spv_12".tr()) {
      return colorError;
    } else if (text == "contact_spv_13".tr()) {
      return colorSecondaryYellow;
    } else if (text == "contact_spv_11".tr()) {
      return colorClear;
    } else {
      return colorGoogle;
    }
  }
}
/// Cek dlu msg terakhir punya w atau bukan. Kalau bukan, cek status message punya sendiri yang terakhir, jika 1 dah di read kalo 0 pendinf.