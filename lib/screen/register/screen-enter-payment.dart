import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/pricing-model.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';

class EnterPayment extends StatefulWidget {
  EnterPayment({Key key, this.title, this.token, this.paketID, this.pricing})
      : super(key: key);
  final String title;
  final String token;
  final String paketID;
  final PricingModel pricing;
  @override
  _EnterPaymentScreen createState() => _EnterPaymentScreen();
}

/// This is the stateless widget that the main application instantiates.
class _EnterPaymentScreen extends State<EnterPayment> {
  final textCardNumber = TextEditingController();
  final textMMYY = TextEditingController();
  final textCVC = TextEditingController();
  final textCardName = TextEditingController();
  final textStreetAddress = TextEditingController();
  final textCity = TextEditingController();
  final textProvince = TextEditingController();
  final textZipCode = TextEditingController();
  bool _cardNumberValidator = false;
  bool _cvcValidator = false;
  bool _mmyyValidator = false;
  bool _cardNameValidator = false;
  bool _streetValidator = false;
  bool _cityValidator = false;
  bool _provinceValidator = false;
  bool _zipCodeValidator = false;
  bool _countryValidator = false;
  List<String> countries = [
    "---Select Country---",
    "Australia",
    "China",
    "Indonesia",
    "Japan",
    "South Korea",
    "USA"
  ];
  String country = "";
  bool error = false;
  bool notEmpty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    country = countries[0];
  }

  _errorFalse() {
    setState(() {
      error = false;
      notEmpty = true;
    });
  }

  _errorTrue() {
    setState(() {
      error = true;
    });
  }

  _testingData() {
    if (textCardNumber.text != "" && textCardNumber.text.length > 14) {
      setState(() {
        _cardNumberValidator = false;
      });
    } else {
      setState(() {
        _cardNumberValidator = true;
      });
    }
    if (textMMYY.text != "") {
      setState(() {
        _mmyyValidator = false;
      });
    } else {
      setState(() {
        _mmyyValidator = true;
      });
    }
    if (textCVC.text != "") {
      setState(() {
        _cvcValidator = false;
      });
    } else {
      setState(() {
        _cvcValidator = true;
      });
    }
    if (textCardName.text != "") {
      setState(() {
        _cardNameValidator = false;
      });
    } else {
      setState(() {
        _cardNameValidator = true;
      });
    }
    if (textStreetAddress.text != "") {
      setState(() {
        _streetValidator = false;
      });
    } else {
      setState(() {
        _streetValidator = true;
      });
    }
    if (textCity.text != "") {
      setState(() {
        _cityValidator = false;
      });
    } else {
      setState(() {
        _cityValidator = true;
      });
    }
    if (textProvince.text != "") {
      setState(() {
        _provinceValidator = false;
      });
    } else {
      setState(() {
        _provinceValidator = true;
      });
    }
    if (textZipCode.text != "") {
      setState(() {
        _zipCodeValidator = false;
      });
    } else {
      setState(() {
        _zipCodeValidator = true;
      });
    }

    if (country != countries[0]) {
      setState(() {
        _countryValidator = false;
      });
    } else {
      setState(() {
        _countryValidator = true;
      });
    }
    if (!_cardNumberValidator &&
        !_mmyyValidator &&
        !_cvcValidator &&
        !_cardNameValidator &&
        !_streetValidator &&
        !_countryValidator &&
        !_cityValidator &&
        !_provinceValidator &&
        !_zipCodeValidator) {
      _goto();
    }
  }

  _goto() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaymentApproved(token: widget.token, paketID: widget.paketID)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Container(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleFormatCenter(
                  size: size,
                  title: "Enter Payment",
                  detail:
                      "Company account registered after your monthly plan starts.",
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: colorBorder))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: paddingVertical),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enterprise Plan",
                              style: TextStyle(
                                  fontSize: size.height < 569 ? 14 : 16),
                            ),
                            SizedBox(
                              height: size.height < 569 ? 3 : 5,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: size.height < 569 ? 10 : 12,
                                        color: colorNeutral3),
                                    children: [
                                  TextSpan(text: "Plan ahead? "),
                                  TextSpan(
                                      text: "Contact Us!",
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {})
                                ]))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: size.height < 569 ? 14 : 16,
                                        color: Colors.black),
                                    children: [
                                  TextSpan(text: "Rp. "),
                                  TextSpan(
                                    text: widget.pricing.price.toString(),
                                  )
                                ])),
                            SizedBox(
                              height: size.height < 569 ? 3 : 5,
                            ),
                            Text(
                              "billed monthly",
                              style: TextStyle(
                                  color: colorNeutral3,
                                  fontSize: size.height < 569 ? 10 : 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: paddingVertical),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subscription",
                            style: TextStyle(
                                fontSize: size.height < 569 ? 14 : 16)),
                        Text(
                          "Rp." + "1.000.000",
                          style:
                              TextStyle(fontSize: size.height < 569 ? 18 : 20),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "+ sales tax",
                    style: TextStyle(
                        color: colorNeutral3,
                        fontSize: size.height < 569 ? 10 : 12),
                  ),
                ),
                SizedBox(
                  height: size.height < 569 ? 15 : 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Credit Card or Debit Card",
                      style: TextStyle(fontSize: size.height < 569 ? 14 : 16)),
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _cardNumberValidator
                                ? colorError
                                : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textCardNumber,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Card Number",
                            hintStyle: TextStyle(
                              color: _cardNumberValidator
                                  ? colorError
                                  : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    _mmyyValidator ? colorError : colorBorder),
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textMMYY,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                hintText: "MM/YY",
                                hintStyle: TextStyle(
                                  color: _mmyyValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        )),
                    Container(
                        width: size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    _cvcValidator ? colorError : colorBorder),
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textCVC,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                hintText: "CVC",
                                hintStyle: TextStyle(
                                  color: _cvcValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _cardNameValidator ? colorError : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textCardName,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Cardholder's name",
                            hintStyle: TextStyle(
                              color: _cardNameValidator
                                  ? colorError
                                  : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _streetValidator ? colorError : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textStreetAddress,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Street Adress",
                            hintStyle: TextStyle(
                              color:
                                  _streetValidator ? colorError : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _countryValidator ? colorError : colorBorder),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: 12),
                              errorStyle:
                                  TextStyle(color: colorError, fontSize: 16.0),
                              hintText: 'Your Bussiness Scope',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          isEmpty: country == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: country,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  country = newValue;
                                });
                              },
                              items: countries.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _cityValidator ? colorError : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textCity,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "City",
                            hintStyle: TextStyle(
                              color:
                                  _cityValidator ? colorError : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _provinceValidator ? colorError : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textProvince,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Province",
                            hintStyle: TextStyle(
                              color: _provinceValidator
                                  ? colorError
                                  : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 5 : 10,
                ),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _zipCodeValidator ? colorError : colorBorder),
                        color: colorBackground,
                        boxShadow: [boxShadowStandard],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        controller: textZipCode,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Zip Code",
                            hintStyle: TextStyle(
                              color: _zipCodeValidator
                                  ? colorError
                                  : colorNeutral2,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
                SizedBox(
                  height: size.height < 569 ? 15 : 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          primary: colorBackground,
                          side: BorderSide(width: 1, color: colorPrimary)),
                      child: Container(
                        height: 45,
                        width: 0.26 * size.width,
                        child: Center(
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height < 569 ? 12 : 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _testingData();
                        //_goto();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          primary: colorPrimary,
                          side: BorderSide(
                            width: 1,
                            color: colorPrimary,
                          )),
                      child: Container(
                        height: 45,
                        width: 0.43 * size.width,
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: colorBackground,
                                fontSize: size.height < 569 ? 12 : 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
