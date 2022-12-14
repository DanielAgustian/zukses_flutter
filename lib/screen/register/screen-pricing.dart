import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/register/pricing-card.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/screen/register/screen-enter-payment.dart';

class Pricing extends StatefulWidget {
  Pricing({Key key, this.title, this.token}) : super(key: key);
  final String title;
  final String token;
  @override
  _PricingScreen createState() => _PricingScreen();
}

/// This is the stateless widget that the main application instantiates.
class _PricingScreen extends State<Pricing> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PricingBloc>(context).add(GetPricingEvent());
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
                  title: "pricing_text1".tr(),
                  detail: "pricing_text2".tr(),
                ),
                BlocBuilder<PricingBloc, PricingState>(
                    builder: (context, state) {
                  if (state is PricingStateSuccess) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PricingCard(
                          price: state.pricing[0],
                          size: size,
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterPayment(
                                          token: widget.token,
                                          paketID: state.pricing[0].planId
                                              .toString(),
                                          pricing: state.pricing[0],
                                        )));
                          },
                        ),
                        SizedBox(
                          height: size.height < 569 ? 5 : 10,
                        ),
                        PricingCard2(
                          price: state.pricing[1],
                          size: size,
                          onClick: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
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
                          "pricing_text11".tr(),
                          style: TextStyle(
                              color: colorGoogle,
                              fontSize: size.height < 569 ? 12 : 14),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "contact_us_text".tr(),
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
