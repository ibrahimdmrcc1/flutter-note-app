import 'package:flutter/material.dart';
import 'package:flutter_note_app/responsive/size_config.dart';
import 'package:flutter_note_app/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavyBar extends StatefulWidget {
  @override
  _BottomNavyBarState createState() => _BottomNavyBarState();
}

class _BottomNavyBarState extends State<BottomNavyBar> {


  var noteTitleStyle =  GoogleFonts.roboto(color: Colors.black);
  int selectedIndex = 0;
  Color backgroundColor = Colors.white;

  List<NavigationItem> items = [
    NavigationItem(Icon(FontAwesomeIcons.stickyNote), Text("Notlar"),homeButtonColor),
    NavigationItem(Icon(FontAwesomeIcons.plus), Text("Yaz"),noteButtonColor),
    NavigationItem(Icon(Icons.list), Text("Kategoriler"),categoryButtonColor),
  ];

  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: double.maxFinite,
      width: isSelected
          ? SizeConfig.blockSizeHorizontal * 35
          : SizeConfig.blockSizeHorizontal * 10,
      decoration: isSelected
          ? BoxDecoration(
              color: item.color,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeVertical * 3))
          : null,
      child: ListView(
        padding: EdgeInsets.only(left: 15),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                child: item.icon,
                data: IconThemeData(
                  color:  bottomIconColor,
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 8)),
              isSelected
                  ? DefaultTextStyle.merge(
                      style: bottomBarFont,
                      child: item.title)
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeVertical*3) ,topLeft: Radius.circular(SizeConfig.blockSizeVertical*3)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeVertical*3) ,topLeft: Radius.circular(SizeConfig.blockSizeVertical*3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0.0,1.0),
              blurRadius: 6,
              spreadRadius: 2,

            ),
          ],
        ),
        width: SizeConfig.screenWidth,
        height: SizeConfig.blockSizeVertical * 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            var itemIndex = items.indexOf(item);
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = itemIndex;
                  });
                },
                child: _buildItem(item, selectedIndex == itemIndex));
          }).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final Color color;
  final Icon icon;
  final Text title;

  NavigationItem(this.icon, this.title, this.color);
}
