import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';



var textTitleStyle = GoogleFonts.roboto(color: Colors.white);
var greyColor = Color(0xff292929);
var darkBackColor = Colors.white;


var h2Text = GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold,fontSize: 21,color: Color(0xffffffff));
var body2 = GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold,fontSize: 14,color: Color(0xffffffff));
var hintTextStyle = GoogleFonts.titilliumWeb(fontSize: 14,fontWeight:FontWeight.w600,color: Color(0xccffffff));
var bottomBarFont = GoogleFonts.titilliumWeb(color: Color.fromRGBO(77, 182, 172 , 1),fontSize: 15);

const materialColor = Color.fromRGBO(255, 138, 101,1);
const materialColorShade = Color.fromRGBO(255, 138, 101,0.4);
var titleStyle = TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black54);




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