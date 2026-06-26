import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDefaults {
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.height < 700;

  static String appName = "GymKlout";

  static Color primaryColor = const Color(0xFFbf5af2);
  static Color secondaryColor = const Color(0xFFfed75b);
  static Color textColor = const Color(0xFF6C6C6F);
  static Color headerTextColor = const Color.fromARGB(255, 19, 19, 20);
  static Color bgColor = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color darkBgColor = Color(0xFF1c1c1e);
  static Color white = const Color(0xFFFFFFFF);
  static Color fadedWhite = const Color.fromARGB(255, 213, 211, 219);
  static Color virtualCardBG = const Color(0xFFFFFFFF);
  static Color disabledButtonColor = const Color.fromARGB(255, 255, 255, 255);
  static Color errorColor = const Color(0xFFDC2626);
  static Color successColor = const Color(0XFF28A745);

  static TextStyle headLiner1(BuildContext context) => TextStyle(
    fontSize: isSmallScreen(context) ? 22 : 26,
    color: headerTextColor,
    fontWeight: FontWeight.w900,
  );

  static TextStyle defaultButtonStyle(BuildContext context) => TextStyle(
    color: white,
    fontSize: isSmallScreen(context) ? 14 : 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle defaultOutlineButtonStyle(BuildContext context) => TextStyle(
    color: primaryColor.withAlpha(140),
    fontSize: isSmallScreen(context) ? 15 : 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headLine3(BuildContext context) => TextStyle(
    fontSize: isSmallScreen(context) ? 15 : 18,
    color: headerTextColor,
    fontWeight: FontWeight.w300,
  );

  static TextStyle textStyle(BuildContext context) => TextStyle(
    fontSize: isSmallScreen(context) ? 14 : 16,
    color: textColor,
    fontWeight: FontWeight.w300,
  );

  static EdgeInsets defaultPadding = const EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 20,
  );

  static SizedBox myButtonLoading = SizedBox(
    width: 20,
    height: 20,
    child: Platform.isIOS
        ? CupertinoActivityIndicator(color: AppDefaults.primaryColor)
        : CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppDefaults.primaryColor),
          ),
  );

  static SizedBox myErrorButtonLoading = SizedBox(
    width: 20,
    height: 20,
    child: Platform.isIOS
        ? CupertinoActivityIndicator(color: AppDefaults.primaryColor)
        : CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppDefaults.primaryColor),
          ),
  );
}

//  Color functions

Color lighten(Color color, [double amount = .3]) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

Color darken(Color color, [double amount = .3]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

final NumberFormat nairaFormatter = NumberFormat.currency(
  locale: 'en_NG',
  symbol: '₦',
);

final numberFormatter = NumberFormat.decimalPattern('en_NG')
  ..minimumFractionDigits = 2
  ..maximumFractionDigits = 2;

// Title case formatter
String toTitleCase(String text) {
  return text
      .split(' ')
      .map(
        (word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}

