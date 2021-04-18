import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_note_app/models/kategori_model.dart';
import 'package:flutter_note_app/responsive/size_config.dart';
import 'package:flutter_note_app/styles.dart';
import 'package:flutter_note_app/utils/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/not_model.dart';

class NotDetay extends StatefulWidget {
  Function callback;
  Function callbackBottombar;

  String baslik;
  Not duzenlenecekNot;

  NotDetay(
      {this.baslik,
      this.duzenlenecekNot,
      this.callback,
      this.callbackBottombar});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();

  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  int kategoriID;
  int secilenOncelik;

  String notBaslik;
  String notIcerik;

  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();

    databaseHelper = DatabaseHelper();
    databaseHelper.kategoriGetir().then((kategorileriIcerenMapListesi) {
      for (Map okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }

      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot.kategoriID;
        secilenOncelik = widget.duzenlenecekNot.notOncelik;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return tumKategoriler.length <= 0
        ? Center(
            child: Container(
                height: SizeConfig.blockSizeVertical * 80,
                width: SizeConfig.screenWidth,
                color: Colors.white,
                child: CircularProgressIndicator()))
        :Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 5,
            right: SizeConfig.blockSizeHorizontal * 1,
            left: SizeConfig.blockSizeHorizontal * 2),
        color: darkBackColor,
        height: SizeConfig.screenHeight,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text("Öncelik ", style: titleStyle),
                  // Container(
                  //   height: SizeConfig.blockSizeVertical * 6,
                  //   padding:
                  //   EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  //   margin: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //       color: materialColor,
                  //       border: Border.all(
                  //         color: Theme.of(context).primaryColor,
                  //         width: 2,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton(
                  //         dropdownColor: materialColor,
                  //         items: _oncelik.map((oncelik) {
                  //           return DropdownMenuItem<int>(
                  //             child: Text(
                  //               oncelik,
                  //               style: body2,
                  //             ),
                  //             value: _oncelik.indexOf(oncelik),
                  //           );
                  //         }).toList(),
                  //         value: secilenOncelik,
                  //         onChanged: (secilenOncelikID) {
                  //           setState(
                  //                 () {
                  //               secilenOncelik = secilenOncelikID;
                  //             },
                  //           );
                  //         }),
                  //   ),
                  // ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  Text(
                    "Kategori ",
                    style: titleStyle,
                  ),
                  Container(
                    height: SizeConfig.blockSizeVertical * 8,
                    padding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: materialColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: greyColor,
                          items: kategoriItemleriOlustur(),
                          value: kategoriID,
                          onChanged: (secilenKategoriID) {
                            setState(
                                  () {
                                kategoriID = secilenKategoriID;
                              },
                            );
                          }),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.duzenlenecekNot != null
                      ? widget.duzenlenecekNot.notBaslik
                      : "",
                  validator: (text) {
                    if (text.length < 1) {
                      return "En az 3 karakter giriniz ";
                    }
                  },
                  onSaved: (text) {
                    notBaslik = text;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyColor,
                    labelText: "Başlık",
                    labelStyle: hintTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.duzenlenecekNot != null
                      ? widget.duzenlenecekNot.notIcerik
                      : "",
                  onSaved: (text) {
                    notIcerik = text;
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyColor,
                    labelText: "İçerik",
                    labelStyle: hintTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      this.widget.callback(0);
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 6,
                      width: SizeConfig.blockSizeHorizontal*20,
                      padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffE22C21),),
                      child: Center(
                        child: Text(
                          "Vazgeç",
                          style: body2,
                        ),
                      ),

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        var suan = DateTime.now();
                        if (widget.duzenlenecekNot == null) {
                          databaseHelper
                              .notEkle(Not(kategoriID, notBaslik, notIcerik,
                              suan.toString(), secilenOncelik))
                              .then((kaydedilenNotID) {
                            print("Şuan " + suan.toString());
                            print(databaseHelper.dateFormat(suan));
                            if (kaydedilenNotID != 0) {
                              this.widget.callback(0);
                            }
                          });
                        } else {
                          databaseHelper
                              .notGuncelle(Not.withID(
                              widget.duzenlenecekNot.notID,
                              kategoriID,
                              notBaslik,
                              notIcerik,
                              suan.toString(),
                              secilenOncelik))
                              .then((guncellenenID) {
                            if (guncellenenID != 0) {
                              Navigator.pop(context);
                            }
                          });
                        }
                      }
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 6,
                      width: SizeConfig.blockSizeHorizontal*20,
                      padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Text(
                          "Kaydet",
                          style: body2,
                        ),
                      ),

                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {
    List<DropdownMenuItem<int>> kategoriler = [];

    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              value: kategori.kategoriID,
              child: Text(
                kategori.kategoriBaslik,
                style: body2,
              ),
            ))
        .toList();
  }
}

/**
 *
 *
 * Form(
    key: formKey,
    child: Column(
    children: [
    Center(
    child: tumKategoriler.length <= 0 ? CircularProgressIndicator() :
    Container(
    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 12),
    margin: EdgeInsets.all(12),
    decoration: BoxDecoration(
    border: Border.all(color: Theme.of(context).primaryColor,width: 2),
    borderRadius: BorderRadius.circular(10)
    ),
    child: DropdownButtonHideUnderline(
    child: DropdownButton<int>(
    items: kategoriItemleriOlustur(),
    value: kategoriID,
    onChanged: (secilenKategoriID) {
    setState(() {
    kategoriID = secilenKategoriID;
    });
    }),
    ),
    ),
    )
    ],
    ),
    ),
 */
