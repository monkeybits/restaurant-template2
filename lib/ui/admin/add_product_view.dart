import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/constant/route_paths.dart';
import 'package:flutterrestaurant/provider/product/favourite_product_provider.dart';
import 'package:flutterrestaurant/repository/product_repository.dart';
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

class AddProductView extends StatefulWidget {
  const AddProductView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<AddProductView>
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
    _getCategories();
    _getSubcategories();
    super.initState();
  }

  _getCategories() async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection("lowcostapps")
        .doc("tinpanalley")
        .collection("categories");
    var document = await categories.get();
    List<Map> categoriesList = [];
    document.docs.forEach((doc) {
      var category = doc.data();
      print(category);
      categoriesList.add(category);
    });
    setState(() {
      categoryList = categoriesList;
      categoryChoosen['name'] = categoriesList[0]['name'];
      categoryChoosen['id'] = categoriesList[0]['id'];
    });
  }

  _getSubcategories() async {
    CollectionReference subcategories = FirebaseFirestore.instance
        .collection("lowcostapps")
        .doc("tinpanalley")
        .collection("subcategories");
    var document = await subcategories.get();
    List<Map> subcategoriesList = [];
    document.docs.forEach((doc) {
      var subcategory = doc.data();
      print(subcategory);
      subcategoriesList.add(subcategory);
    });
    setState(() {
      subcategoryList = subcategoriesList;
      subcategoryChoosen['name'] = subcategoriesList[0]['name'];
      subcategoryChoosen['id'] = subcategoriesList[0]['id'];
    });
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
      onSaved: (value) => product_name = value,
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

    TextFormField categoryDescription(String title, IconData icon) {
    return TextFormField(
      initialValue: "",
      onSaved: (value) => product_description = value,
      validator: (value) => value.length < 3
          ? "Attenzione, inserire descrizione"
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

    TextFormField categoryIngredient(String title, IconData icon) {
    return TextFormField(
      initialValue: "",
      onSaved: (value) => product_ingredient = value,
      validator: (value) => value.length < 3
          ? "Attenzione, inserire ingredienti (separa con la virgola)"
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
   TextFormField categoryPrice(String title, IconData icon) {
    return TextFormField(
      initialValue: "",
      onSaved: (value) => product_price = value,
      validator: (value) => value.length < 3
          ? "Attenzione, inserire prezzo"
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

  DropdownButton category(List<Map> categoryList, String title, IconData icon) {
    return new DropdownButton<String>(
      icon: Icon(icon),
      isExpanded: true,
      items: categoryList.map((Map value) {
        return new DropdownMenuItem<String>(
          value: value['name'],
          child: new Text(value['name']),
        );
      }).toList(),
      value: categoryChoosen['name'],
      onChanged: (newValue) {
        category_id = newValue;
        for (var cat in categoryList) {
          if (cat['name'] == newValue) {
            setState(() {
              categoryChoosen['name'] = newValue;
              categoryChoosen['id'] = cat['id'];
            });
          }
        }
        ;
      },
    );
  }

  DropdownButton subcategory(List<Map> subcategoryList, String title, IconData icon) {
    return new DropdownButton<String>(
      icon: Icon(icon),
      isExpanded: true,
      items: subcategoryList.map((Map value) {
        return new DropdownMenuItem<String>(
          value: value['name'],
          child: new Text(value['name']),
        );
      }).toList(),
      value: subcategoryChoosen['name'],
      onChanged: (newValue) {
        category_id = newValue;
        for (var subcat in subcategoryList) {
          if (subcat['name'] == newValue) {
            setState(() {
              subcategoryChoosen['name'] = newValue;
              subcategoryChoosen['id'] = subcat['id'];
            });
          }
        }
        ;
      },
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
  String product_name;
  String product_ingredient;
  String product_description;
  String product_price;
  String category_id;
  String dropdownvalueCAT;
  List<Map> categoryList = [];
  List<Map> subcategoryList = [];
  Map categoryChoosen = {'id': '', 'name': ''};
  Map subcategoryChoosen = {'id': '', 'name': ''};


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
                                  category(categoryList, "categoria",
                                      Icons.category),
                                  SizedBox(height: 20),
                                  subcategory(subcategoryList, "sub-categoria",
                                      Icons.category),
                                  SizedBox(height: 20),
                                  categoryName("inserire nome",
                                      Icons.account_box_rounded),
                                  SizedBox(height: 20),
                                   categoryDescription("inserire descrizione",
                                      Icons.account_box_rounded),
                                  SizedBox(height: 20),
                                   categoryIngredient("inserire ingredienti (separa con virgola)",
                                      Icons.account_box_rounded),
                                  SizedBox(height: 20),
                                  categoryPrice("inserire prezzo",
                                      Icons.account_box_rounded),
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
                                          print(product_name);
                                          //await _con.editProfile(user.toMap());
                                          firebase_storage.FirebaseStorage
                                              firebaseStorageRef =
                                              firebase_storage
                                                  .FirebaseStorage.instance;
                                          firebase_storage.Reference ref =
                                              firebaseStorageRef.ref().child(
                                                  'products/' +
                                                      product_name +
                                                      '_image');
                                          firebase_storage.Reference ref_icon =
                                              firebaseStorageRef.ref().child(
                                                  'products/' +
                                                      product_name +
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
                                                   CollectionReference
                                                      category =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "lowcostapps")
                                                          .doc("tinpanalley")
                                                          .collection(
                                                              "categories");
                                                  var documentCat = await category.doc(categoryChoosen['id']).get();
                                                  CollectionReference
                                                      subcategory =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "lowcostapps")
                                                          .doc("tinpanalley")
                                                          .collection(
                                                              "subcategories");
                                                  var documentSubCat = await subcategory.doc(subcategoryChoosen['id']).get();
                                                  CollectionReference
                                                      products =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "lowcostapps")
                                                          .doc("tinpanalley")
                                                          .collection(
                                                              "products");
                                                  var uuid = Uuid();
                                                  var document =
                                                      await products
                                                          .doc(uuid.v4())
                                                          .set({
                                                    'id': uuid.v4(),
                                                    'cat_id':
                                                        categoryChoosen['id'],
                                                    'sub_cat_id': subcategoryChoosen['id'],
                                                    'name': product_name,
                                                    // 'default_icon': {
                                                    //   'img_path': value2
                                                    // },
                                                    'default_photo': {
                                                      'img_path': value
                                                    },
                                                    'description': product_description,
                                                    'ingredient': product_ingredient,
                                                    'nutrient': product_ingredient,
                                                    'original_price': product_price,
                                                    'unit_price': product_price,
                                                    'shipping_cost': '0',
                                                    'currency_symbol': '€',
                                                    'is_available': '1',
                                                    'minimum_order': '1',
                                                    'discount_amount': '0',
                                                    'discount_percent': '0',
                                                    'discount_value': '0',
                                                    'currency_short_form': 'euro',
                                                    'category': documentCat.data(),
                                                    'sub_category': documentSubCat.data(),
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
