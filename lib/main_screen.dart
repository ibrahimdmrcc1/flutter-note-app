import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_note_app/responsive/size_config.dart';
import 'package:flutter_note_app/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'kategori_islemleri.dart';
import 'main.dart';
import 'not_detay.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex;
  List<Widget> pages;
  List<String> appbarText;

  NotListesi notListesi;
  NotDetay notDetay;
  Kategoriler kategoriler;

  void initState() {
    // TODO: implement initState
    notDetay = NotDetay(callback: this.callback);
    notListesi = NotListesi();
    kategoriler = Kategoriler();
    pages = [notListesi, notDetay, kategoriler];
    appbarText = ["Notlarım", "Yeni Not", "Kategoriler"];
    selectedIndex = 0;
    super.initState();
  }

  void callback(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: materialColor,
          toolbarHeight: SizeConfig.blockSizeVertical * 9,
          title: Center(
            child: Text(
              appbarText[selectedIndex],
              style: h2Text,
            ),
          ),
        ),
        body: Stack(
          children: [
            pages[selectedIndex],
            Positioned(bottom: 0, child: buildClipRRect()),
          ],
        ));
  }


  ClipRRect buildClipRRect() {

    List<NavigationItem> items = [
      NavigationItem(
          Icon(Icons.home), Text("Notlar"), materialColor),
      NavigationItem(Icon(Icons.add), Text("Yaz"), materialColor),
      NavigationItem(Icon(Icons.list), Text("Kategoriler"), materialColor),
    ];

    return ClipRRect(

      child: Container(
        padding:
        EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
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

  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: double.maxFinite,
      width: isSelected
          ? SizeConfig.blockSizeHorizontal * 20
          : SizeConfig.blockSizeHorizontal * 10,
      decoration: isSelected
          ? BoxDecoration(
          color: item.color,
          borderRadius:
          BorderRadius.circular(SizeConfig.blockSizeVertical * 3))
          : null,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              child: item.icon,
              data: IconThemeData(
                color: isSelected ? Colors.white:materialColor,
              ),
            ),
          ],
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
