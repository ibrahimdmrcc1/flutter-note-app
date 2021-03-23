import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/kategori_islemleri.dart';
import 'package:flutter_note_app/not_detay.dart';
import 'package:flutter_note_app/utils/database_helper.dart';

import 'models/kategori_model.dart';
import 'models/not_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatefulWidget {
  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text("Notlarım"),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.category),
                  title: Text("Kategoriler"),
                  onTap: () {
                    Navigator.pop(context);
                    _kategorilerSayfasinaGit(context);
                  },
                ),
              )
            ];
          }),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Kategori Ekle",
            heroTag: "KategoriEkle",
            onPressed: () {
              kategoriEkleDialog(context);
            },
            child: Icon(
              Icons.add_circle,
            ),
            mini: true,
          ),
          FloatingActionButton(
            onPressed: () async {
              _detaySayfasinaGit(context);
            },
            tooltip: "Not Ekle",
            heroTag: "NotEkle",
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi.length < 3) {
                        return "En az 3 karakter giriniz";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Kategori Eklendi"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni Not",
                ))).then((value) => setState(() {}));
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kategoriler()))
        .then((value) => setState(() {}));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
  }

  @override
  // build o ekrana her geldiğinde çalışır
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data;
          sleep(Duration(microseconds: 1000));
          return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                  title: Text(tumNotlar[index].notBaslik),
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tumNotlar[index].kategoriBaslik,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),

                          // olusturma tarihi iptall
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Oluşturulma Tarihi",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: databaseHelper.date(
                                         _tarihAyirFonksiyonu(
                                            tumNotlar[index].notTarih)),
                                    builder: Text(data),
                                  ))
                            ],
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tumNotlar[index].notIcerik,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              FlatButton(
                                  onPressed: () =>
                                      _notSil(tumNotlar[index].notID),
                                  child: Text("SİL")),
                              FlatButton(
                                  onPressed: () {
                                    _detaySayfasinaGit(
                                        context, tumNotlar[index]);
                                  },
                                  child: Text(
                                    "DÜZENLE",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              });
        } else {
          return Center(
            child: Text("Yükleniyor..."),
          );
        }
      },
    );
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Notu Düzenle",
                  duzenlenecekNot: not,
                ))).then((value) => setState(() {}));
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text(
            "AZ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade100,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text(
            "ORTA",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade200,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text(
            "ACİL",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade700,
        );

        break;
    }
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Not başarıyla silindi"),
          backgroundColor: Colors.red,
        ));
        setState(() {});
      }
    });
  }

/*  Future<DateTime> _tarihAyirFonksiyonu(String notTarih) async{
    
    List<String> items = List<String>();
    items = notTarih.split("-");
    int year = int.parse(items[0]);
    int month = int.parse(items[1]);
    items = items[2].split(" ");
    int day = int.parse(items[0]);

    return DateTime(year,month,day);
    
    
  }*/
}
