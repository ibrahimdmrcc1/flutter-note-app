import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/kategori_model.dart';
import 'package:flutter_note_app/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      _kategoriListesiniGuncelle();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Kategoriler"),
        ),
        body: ListView.builder(
            itemCount: tumKategoriler.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  _kategoriGuncelle(tumKategoriler[index],context);
                },
                title: Text(tumKategoriler[index].kategoriBaslik),
                trailing: InkWell(
                  child: Icon(Icons.delete),
                  onTap: () => _kategoriSil(tumKategoriler[index].kategoriID),
                ),
                leading: Icon(Icons.category),
              );
            }));
  }

  void _kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Sil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Bu kategori silinirse bununla ilgili tüm notlar silinecektir. Emin misiniz ?"),
                ButtonBar(
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Vazgeç")),
                    FlatButton(
                        onPressed: () {
                          databaseHelper
                              .kategoriSil(kategoriID)
                              .then((silinenKategori) {
                            if (silinenKategori != 0) {
                              setState(() {
                                _kategoriListesiniGuncelle();
                                Navigator.of(context).pop();
                              });
                            }
                          });
                        },
                        child: Text("Kategoriyi Sil")),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _kategoriGuncelle(Kategori guncellenecekKategori,BuildContext c) {
    kategoriGuncelleDialog(c, guncellenecekKategori);
  }

  void kategoriGuncelleDialog(
      BuildContext myContext, Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();
    String guncellenecekKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: myContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Güncelle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: guncellenecekKategori.kategoriBaslik,
                    onSaved: (yeniDeger) {
                      guncellenecekKategoriAdi = yeniDeger;
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
                            .kategoriGuncelle(Kategori.withID(
                                guncellenecekKategori.kategoriID,
                                guncellenecekKategoriAdi))
                            .then((katID) {
                          if (katID != 0) {
                            Scaffold.of(myContext).showSnackBar(SnackBar(
                              content: Text("Kategori Güncellendi"),
                              backgroundColor: Colors.yellow,
                              duration: Duration(seconds: 2),
                            ));
                            _kategoriListesiniGuncelle();
                            Navigator.pop(context);
                          }
                        });
                        /*databaseHelper
                            .kategoriEkle(Kategori(guncellenecekKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Kategori Eklendi"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });*/
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
}
