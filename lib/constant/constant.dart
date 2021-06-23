import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

const colorPrimary = Color(0xFF142B6F);
const colorPrimary70 = Color(0xFF5B6B9B);
const colorPrimary50 = Color(0xFF8A95B7);
const colorPrimary30 = Color(0xFFB9C0D4);

const colorPrimaryGradient1 = Color(0xFF00224D);
const colorPrimaryGradient2 = Color(0xFF002F5F);
const colorPrimaryGradient3 = Color(0xFF002435);

const colorSecondaryRed = Color(0xFFF05769);
const colorSecondaryRed70 = Color(0xFFF58A96);
const colorSecondaryRed50 = Color(0xFFF8ABB4);
const colorSecondaryRed30 = Color(0xFFFBCDD2);

const colorSecondaryYellow = Color(0xFFFFD602);
const colorSecondaryYellow70 = Color(0xFFFFE34E);
const colorSecondaryYellow50 = Color(0xFFFFEB81);
const colorSecondaryYellow30 = Color(0xFFFFF3B4);

const colorNeutral1 = Color(0xFFE1DEE5);
const colorNeutral170 = Color(0xFFEAE8ED);
const colorNeutral150 = Color(0xFFF0EFF2);
const colorNeutral130 = Color(0xFFF6F6F8);

const colorNeutral2 = Color(0xFFC4C4C4);

const colorClear = Color(0xFF1BB55C);
const colorError = Color(0xFFE74C3C);
const colorBackground = Color(0xFFF9FBFB);
const colorGoogle = Color(0xFF121212);
const colorFacebook = Color(0xFF142B6F);
const colorNeutral3 = Color(0xFF7B7B7B);
const colorSkeleton = Color(0xFFa1a1a1);
const colorOrange = Color(0xFFFF8C00);
const colorShadow = Color(0xFF1C1C1E);
const colorBorder = Color(0xFFBFBFBF);
Widget dotYellow = Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
        color: colorSecondaryYellow, borderRadius: BorderRadius.circular(10)));

Widget dotGreen = Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
        color: colorClear, borderRadius: BorderRadius.circular(10)));

Widget dotRed = Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
        color: colorSecondaryRed, borderRadius: BorderRadius.circular(10)));

Widget dotBlue = Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
        color: colorPrimary, borderRadius: BorderRadius.circular(10)));

Widget dotWhite = Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
        color: colorBackground, borderRadius: BorderRadius.circular(10)));

double textSizeSmall20 = 18;
double textSizeSmall18 = 16;
double textSizeSmall16 = 14;
double textSizeSmall14 = 12;
double textSizeSmall12 = 10;
double paddingHorizontal = 20.0;
double paddingVertical = 5.0;

BoxShadow boxShadowStandard = BoxShadow(
  color: colorShadow.withOpacity(0.07),
  blurRadius: 20,
);
AppBar appBarOutside = AppBar(
  centerTitle: true,
  leading: Container(),
  backgroundColor: colorBackground,
  elevation: 0.0,
  title: Text(
    "ZUKSES",
    style: GoogleFonts.lato(
        textStyle: TextStyle(color: colorPrimary, letterSpacing: 1.5),
        fontSize: 14,
        fontWeight: FontWeight.bold),
  ),
);
const int imageQualityCamera = 60;
const double maxHeight = 400;
const double maxWidth = 320;
