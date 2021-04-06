import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';



var textTitleStyle = GoogleFonts.roboto(color: Colors.white);
var greyColor = Color.fromRGBO(45, 45, 45,100);
var darkBackColor = Color(0xff121212);


var h2Text = GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold,fontSize: 21,color: Color(0xccffffff));
var body2 = GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold,fontSize: 14,color: Color(0xccffffff));
var bottomBarFont = GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold,color: Color(0xccffffff),fontSize: 16);
var noteButtonColor = Color(0xB3A4ADE9);
var homeButtonColor = Color(0xff1194AA);
var categoryButtonColor = Color(0xb383DEC4);
var bottomIconColor = Color(0xccffffff);



MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}