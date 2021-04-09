import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/register/pricing-card.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-data-company.dart';
import 'package:zukses_app_1/screen/register/screen-enter-payment.dart';

class Pricing extends StatefulWidget {
  Pricing({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PricingScreen createState() => _PricingScreen();
}

/// This is the stateless widget that the main application instantiates.
class _PricingScreen extends State<Pricing> {
  _goto() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EnterPayment()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: size.width),
                TitleFormatCenter(
                  size: size,
                  title: "Option Plan",
                  detail: "Choose plan that suits your bussiness better",
                ),
                PricingCard(
                  size: size,
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnterPayment()));
                  },
                ),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                PricingCard2(
                  size: size,
                  onClick: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "For more information or inquiries,",
                          style: TextStyle(
                              color: colorGoogle,
                              fontSize: size.height < 569 ? 12 : 14),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Contact Us!",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height < 569 ? 14 : 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.02 * size.height)
              ],
            ),
          ),
        ));
  }
}
