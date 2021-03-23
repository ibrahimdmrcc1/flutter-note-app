import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/kategori_model.dart';
import 'package:flutter_note_app/utils/database_helper.dart';

import 'models/not_model.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenecekNot;

  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();

  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  int kategoriID ;
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

      if(widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot.kategoriID;
        secilenOncelik = widget.duzenlenecekNot.notOncelik;
      }else{
        kategoriID=1;
        secilenOncelik=0;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            "Kategori: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
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
                            if (text.length < 3) {
                              return "En az 3 karakter giriniz ";
                            }
                          },
                          onSaved: (text) {
                            notBaslik = text;
                          },
                          decoration: InputDecoration(
                            labelText: "Not başlığını giriniz",
                            hintText: "Başlık",
                            border: OutlineInputBorder(),
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
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "Not içeriğini giriniz",
                            hintText: "İçerik",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            "Öncelik: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  items: _oncelik.map((oncelik) {
                                    return DropdownMenuItem<int>(
                                      child: Text(
                                        oncelik,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      value: _oncelik.indexOf(oncelik),
                                    );
                                  }).toList(),
                                  value: secilenOncelik,
                                  onChanged: (secilenOncelikID) {
                                    setState(
                                      () {
                                        secilenOncelik = secilenOncelikID;
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                      ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.redAccent.shade200),
                            child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Vazgeç",
                                style: TextStyle(fontSize: 20),
                              ),
                              color: Colors.redAccent.shade200,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  var suan = DateTime.now();
                                  if (widget.duzenlenecekNot == null) {
                                    databaseHelper
                                        .notEkle(Not(
                                            kategoriID,
                                            notBaslik,
                                            notIcerik,
                                            suan.toString(),
                                            secilenOncelik))
                                        .then((kaydedilenNotID) {
                                      print("Şuan " + suan.toString());
                                      print(databaseHelper.dateFormat(suan));
                                      if (kaydedilenNotID != 0) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    databaseHelper.notGuncelle(Not.withID(
                                        widget.duzenlenecekNot.notID,
                                        kategoriID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString(),
                                        secilenOncelik)).then((guncellenenID) {
                                          if(guncellenenID != 0){
                                            Navigator.pop(context);
                                          }
                                    });
                                  }
                                }
                              },
                              child: Text(
                                "Kaydet",
                                style: TextStyle(fontSize: 20),
                              ),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
                style: TextStyle(fontSize: 20.0),
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
