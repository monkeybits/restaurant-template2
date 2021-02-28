import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/constant/route_paths.dart';
import 'package:flutterrestaurant/provider/product/favourite_product_provider.dart';
import 'package:flutterrestaurant/repository/product_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/ui/product/item/product_vertical_list_item.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterrestaurant/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<AddCategoryView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider _favouriteProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        imageFile = image;
      });
    }
  }

  _getFromGallery2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        iconFile = image;
      });
    }
  }

  TextFormField categoryName(String title, IconData icon) {
    return TextFormField(
      initialValue: "",
      onSaved: (value) => category_name = value,
      validator: (value) => value.length < 3
          ? "Attenzione, inserire il nome della categoria"
          : null,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey),
        icon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  final key = GlobalKey<FormState>();
  File imageFile;
  File iconFile;
  String category_name;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<FavouriteProductProvider>(
      lazy: false,
      create: (BuildContext context) {
        final FavouriteProductProvider provider =
            FavouriteProductProvider(repo: repo1, psValueHolder: psValueHolder);
        provider.loadFavouriteProductList();
        _favouriteProductProvider = provider;
        return _favouriteProductProvider;
      },
      child: Consumer<FavouriteProductProvider>(
        builder: (BuildContext context, FavouriteProductProvider provider,
            Widget child) {
          return Column(
            children: <Widget>[
              // const PsAdMobBannerWidget(),
              Expanded(
                child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space4,
                          right: PsDimens.space4,
                          top: PsDimens.space4,
                          bottom: PsDimens.space4),
                      child: RefreshIndicator(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Form(
                              key: key,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  categoryName("inserire nome",
                                      Icons.account_box_rounded),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      categoryPhoto("inserire nome",
                                          Icons.account_box_rounded),
                                      imageFile != null
                                          ? Container(
                                              height: 50,
                                              width: 50,
                                              child: Image.file(
                                                imageFile,
                                                fit: BoxFit.scaleDown,
                                              ))
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      categoryIcon("inserire nome",
                                          Icons.account_box_rounded),
                                      iconFile != null
                                          ? Container(
                                              height: 50,
                                              width: 50,
                                              child: Image.file(
                                                iconFile,
                                                fit: BoxFit.scaleDown,
                                              ))
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  ButtonTheme(
                                    minWidth: 150.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                      color: Theme.of(context).hintColor,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                      ),
                                      onPressed: () async {
                                        if (key.currentState.validate()) {
                                          firebase_storage.UploadTask
                                              uploadTask;
                                          firebase_storage.UploadTask
                                              uploadTask2;

                                          key.currentState.save();
                                          print(category_name);
                                          //await _con.editProfile(user.toMap());
                                          firebase_storage.FirebaseStorage
                                              firebaseStorageRef =
                                              firebase_storage
                                                  .FirebaseStorage.instance;
                                          firebase_storage.Reference ref =
                                              firebaseStorageRef.ref().child(
                                                  'categories/' +
                                                      category_name +
                                                      '_image');
                                          firebase_storage.Reference ref_icon =
                                              firebaseStorageRef.ref().child(
                                                  'categories/' +
                                                      category_name +
                                                      '_icon');
                                          uploadTask = ref.putFile(imageFile);
                                          uploadTask2 =
                                              ref_icon.putFile(iconFile);
                                          firebase_storage.UploadTask task =
                                              await Future.value(uploadTask);
                                          firebase_storage.UploadTask task2 =
                                              await Future.value(uploadTask2);
                                          task.whenComplete(() {
                                            Future link = ref.getDownloadURL();
                                            link.then((value) {
                                              print(value);
                                              task2.whenComplete(() {
                                                Future link2 =
                                                    ref_icon.getDownloadURL();
                                                link2.then((value2) async {
                                                  print(value2);
                                                  CollectionReference categories = FirebaseFirestore.instance.collection("lowcostapps").doc("tinpanalley").collection("categories");
                                                  var uuid = Uuid();
                                                  var document = await categories.doc(uuid.v4()).set({
                                                    'id': uuid.v4(),
                                                    'name': category_name,
                                                    'default_icon': {
                                                      'img_path': value2
                                                    },
                                                    'default_photo': {
                                                      'img_path': value
                                                    }
                                                  });
                                                  showDialog<dynamic>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return SuccessDialog(
                                                        message: "Category added",
                                                      );
                                                    });
                                                });
                                              });
                                            });
                                          });
                                        }
                                      },
                                      child: Text(
                                        "SALVA",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onRefresh: () {
                          return provider.resetFavouriteProductList();
                        },
                      )),
                  PSProgressIndicator(provider.favouriteProductList.status)
                ]),
              )
            ],
          );
        },
      ),
    );
  }

  categoryPhoto(String title, IconData icon) {
    return RaisedButton(
      color: Colors.greenAccent,
      onPressed: () {
        _getFromGallery();
      },
      child: Text("Inserisci immagine"),
    );
  }

  categoryIcon(String title, IconData icon) {
    return RaisedButton(
      color: Colors.greenAccent,
      onPressed: () {
        _getFromGallery2();
      },
      child: Text("Inserisci icona"),
    );
  }
}
