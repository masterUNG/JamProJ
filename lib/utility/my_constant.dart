import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_fonts/google_fonts.dart';

class MyConstant {
// Genernal
  static String appName = 'อำเภอบ้านหลวง E-service';
  static String domain = 'https://banluang.org/';
  //static String domain = 'http://192.168.100.217/cpknan/';
  //static String domain = 'http://172.20.10.6/cpknan/';
  // Route
  static String routeLogin = '/Login';
  static String routeRegister = '/Register';
  static String routeDashboard = '/Dashboard';
  static String routeAddinformRisk = '/add_informrisk';
  static String routeAddinformdis = '/add_informdis';
  static String routeAdddamrong = '/add_damrong';
  static String routeAddcontact = '/add_contact';
  static String routeAddredcross = '/add_redcross';
  static String routeAddappoint = '/add_appoint';
  static String routeAddnews = '/add_news';
  static String routeAddpr = '/add_pr';
  static String routeAddfaq = '/add_faq';
  static String routeAdmin = '/admin';
  // Image
  static String imglogo = 'images/logo1.jpg';
  static String imagdesk = 'images/desktop.png';
  static String imagig = 'images/ig.png';
  static String imaginfo = 'images/info.png';
  static String imgphoto = 'images/photo.png';
  static String imgwindow = 'images/window.png';
  static String imgaccount = 'images/account.png';
  static String avatar = 'images/avatar.png';
  static String imgdopa = 'images/dopa.png';
  static String develop = 'images/developer.jpg';
  static String imgdisaster = 'images/disaster.jpg';
  static String imgdamrong = 'images/damrong.jpg';
  static String imgappoint = 'images/appoint.png';
  static String imgredcross = 'images/redcross.jpg';
  // Color
  static Color primary = Color(0xfff06292);
  static Color dark = Color(0xffF48FB1);
  static Color light = Color(0xfff8BBD0);

  static Color darkg = Color(0xfffAED581);
  static Color lightg = Color(0xffFDCEDC8);
  static Color primaryg = Color(0xfff8BC34A);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 240, 98, 0.1),
    100: Color.fromRGBO(255, 240, 98, 0.2),
    200: Color.fromRGBO(255, 240, 98, 0.3),
    300: Color.fromRGBO(255, 240, 98, 0.4),
    400: Color.fromRGBO(255, 240, 98, 0.5),
    500: Color.fromRGBO(255, 240, 98, 0.6),
    600: Color.fromRGBO(255, 240, 98, 0.7),
    700: Color.fromRGBO(255, 240, 98, 0.8),
    800: Color.fromRGBO(255, 240, 98, 0.9),
    900: Color.fromRGBO(255, 240, 98, 1.0),
  };

  /*
  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(2255, 244, 143, 0.1),
    100: Color.fromRGBO(255, 244, 143, 0.2),
    200: Color.fromRGBO(255, 244, 143, 0.3),
    300: Color.fromRGBO(255, 244, 143, 0.4),
    400: Color.fromRGBO(255, 244, 143, 0.5),
    500: Color.fromRGBO(255, 244, 143, 0.6),
    600: Color.fromRGBO(255, 244, 143, 0.7),
    700: Color.fromRGBO(255, 244, 143, 0.8),
    800: Color.fromRGBO(255, 244, 143, 0.9),
    900: Color.fromRGBO(255, 244, 143, 1.0),
  };
 */
  //Background
  BoxDecoration planBackground() => BoxDecoration(
        color: MyConstant.light.withOpacity(0.75),
      );

  BoxDecoration gradintLinearBackground() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, MyConstant.light, MyConstant.primary],
        ),
      );

  BoxDecoration gradientRadioBackground() => BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.5,
          colors: [Colors.white, MyConstant.primary],
        ),
      );
  // Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle gh1Style() => GoogleFonts.prompt(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h1blackStyle() => TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  TextStyle h1SWhitetyle() => TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle h1RedStyle() => TextStyle(
        fontSize: 24,
        color: Colors.red.shade900,
        fontWeight: FontWeight.bold,
      );

  TextStyle gh1RedStyle() => GoogleFonts.prompt(
        fontSize: 24,
        color: Colors.red.shade900,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2WhiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );

  TextStyle gh2WhiteStyle() => GoogleFonts.prompt(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );

  TextStyle h2Blacktyle() => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      );

  TextStyle h2RedStyle() => TextStyle(
        fontSize: 18,
        color: Colors.red.shade700,
        fontWeight: FontWeight.w700,
      );

  TextStyle h2BlueStyle() => TextStyle(
        fontSize: 18,
        color: Colors.blue.shade800,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3WhiteStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3RedStyle() => TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.normal,
      );

  TextStyle gh3RedStyle() => GoogleFonts.prompt(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle mydarkbutton() => ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

        ButtonStyle mygreenbutton() => ElevatedButton.styleFrom(
        primary: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

           ButtonStyle myredbutton() => ElevatedButton.styleFrom(
        primary: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
