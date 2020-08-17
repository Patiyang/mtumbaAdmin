import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtumbaAdmin/provider/brandCategoryClothing/brandDatabase.dart';
import 'package:mtumbaAdmin/provider/brandCategoryClothing/categoryDatabase.dart';
import 'package:mtumbaAdmin/provider/brandCategoryClothing/clothingDatabase.dart';
import 'package:mtumbaAdmin/styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddClothing extends StatefulWidget {
  @override
  _AddClothingState createState() => _AddClothingState();
}

class _AddClothingState extends State<AddClothing> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController productNameController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController productCountController = new TextEditingController();
  TextEditingController productDescriptionController = new TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();

  SharedPreferences preferences;
  List<String> selectedSize = <String>[];

  String groupValue = 'New';
  String status;
  String _currentCategory = 'Empty';
  String _currentBrand = 'Empty';
  int price = 1;
  File _image1;
  File _image2;
  File _image3;
  bool loading;
  ImagePicker picker = new ImagePicker();

  @override
  void initState() {
    _getBrands();
    _getCategories();
    categoriesDropDown = getCategoriesDropDown();
    brandsDropDown = getBrandsDropDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
// ======================================ADDING IMAGES========================================
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          borderSide: BorderSide(color: grey[400], width: 2.5),
                          onPressed: () {
                            selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 1);
                          },
                          child: displayChild1()),
                    ),
                  ),
                  SizedBox(height: 2),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        borderSide: BorderSide(color: grey[400], width: 2.5),
                        onPressed: () {
                          selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 2);
                        },
                        child: displayChild2(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        borderSide: BorderSide(color: grey[400], width: 2.5),
                        onPressed: () {
                          selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 3);
                        },
                        child: displayChild3(),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add your product details below',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: grey,
              ),
// ==========================ADDING THE BRAND AND CATEGORY========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      'Category: ',
                      style: TextStyle(color: black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      icon: Icon(
                        Icons.category,
                      ),
                      iconSize: 12,
                      hint: Text('Category'),
                      style: TextStyle(color: black),
                      value: _currentCategory,
                      items: categoriesDropDown,
                      onChanged: changeSelectedCategory,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Brand: ",
                      style: TextStyle(color: black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      hint: Text('Brand'),
                      icon: Icon(Icons.branding_watermark),
                      iconSize: 12,
                      style: TextStyle(color: black),
                      items: brandsDropDown,
                      value: _currentBrand,
                      onChanged: changeSelectedBrand,
                    ),
                  )
                ],
              ),

// ============================================ADDING THE OTHER PARAMETERS=========================================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'product name', hintStyle: TextStyle(color: grey)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'you must enter product name';
                    } else if (value.length > 20) {
                      return 'the characters must be less than 20';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: TextFormField(
                  controller: productPriceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'product Price', hintStyle: TextStyle(color: grey)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'you must enter product price';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: TextFormField(
                  controller: productCountController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Product Count', hintStyle: TextStyle(color: grey)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'you must enter product count';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                child: TextFormField(
                  maxLines: 5,
                  controller: productDescriptionController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Product Description', hintStyle: TextStyle(color: grey)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'you must enter product Description';
                    }
                    return null;
                  },
                ),
              ),

              // ====================================PRODUCT STATUS==================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('New'),
                      SizedBox(width: 10),
                      Radio(activeColor: black,
                        value: 'New',
                        groupValue: groupValue,
                        onChanged: (value) => changeStatus(value),
                      ),
                      SizedBox(width: 40),
                      Text('Used'),
                      SizedBox(width: 10),
                      Radio(activeColor: black,
                        value: 'Used',
                        groupValue: groupValue,
                        onChanged: (value) => changeStatus(value),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: grey,
              ),
              // ========================================PICKING THE AVAILABLE SIZES====================================
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pick available sizes'),
              ),
              FittedBox(fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Checkbox(value: selectedSize.contains('XS'), onChanged: (value) => changeSelectedSize('XS')),
                    Text('XS'),
                    Checkbox(value: selectedSize.contains('S'), onChanged: (value) => changeSelectedSize('S')),
                    Text('S'),
                    Checkbox(value: selectedSize.contains('M'), onChanged: (value) => changeSelectedSize('M')),
                    Text('M'),
                    Checkbox(value: selectedSize.contains('L'), onChanged: (value) => changeSelectedSize('L')),
                    Text('L'),
                    Checkbox(value: selectedSize.contains('XL'), onChanged: (value) => changeSelectedSize('XL')),
                    Text('XL'),
                  ],
                ),
              ),
              // ========================================UPLOADING THE PRODUCT====================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: MaterialButton(
                  elevation: 0,
                  color: orange,
                  onPressed: () async {
                    _formKey.currentState.reset();
                    await uploadProduct();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('Add Product'),
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: loading == true ? true : false,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.7),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orange),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================ADDING CATEGORIES METHODS=======================
  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        if (categories.length == 0 || categories == null) {
          Text('Absent');
        }
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['categoryName']),
              value: categories[i].data['categoryName'],
            ));
      });
    }
    return items;
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();

    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['categoryName'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  // ============================ADDING BRANDS METHOD=========================
  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        if (brands.length == 0 || brands == null) {
          Text('data absent');
        }
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(brands[i].data['brandName']),
              value: brands[i]['brandName'],
            ));
      });
    }
    return items;
  }

  void _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data['brandName'];
    });
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() {
      _currentBrand = selectedBrand;
    });
  }

  // ================================PRODUCT STATUS METHOD & CHOOSING SIZES============================
  changeStatus(String value) {
    setState(() {
      if (value == 'New') {
        groupValue = value;
        status = value;
      } else if (value == 'Used') {
        groupValue = value;
        status = value;
      }
    });
  }

  void changeSelectedSize(String size) {
    if (selectedSize.contains(size)) {
      setState(() {
        selectedSize.remove(size);
      });
    } else {
      setState(() {
        selectedSize.insert(0, size);
      });
    }
  }

  //=======================================UPLOADING PRODUCT AND FORM VALIDATION======================================
  Future uploadProduct() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSize.isNotEmpty) {
          setState(() {
            loading = true;
          });
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;

          final FirebaseStorage storage = FirebaseStorage.instance;
// ===========================ADDING THE 3 IMAGES IN A LIST================================
          final String picture1 = '1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image1);
          StorageTaskSnapshot snap1 = await task1.onComplete.then((snap) => snap);

          final String picture2 = '2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          StorageUploadTask task2 = storage.ref().child(picture2).putFile(_image2);
          StorageTaskSnapshot snap2 = await task2.onComplete.then((snap2) => snap2);

          final String picture3 = '3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          StorageUploadTask task3 = storage.ref().child(picture3).putFile(_image3);

          task3.onComplete.then((snap3) async {
            imageUrl1 = await snap1.ref.getDownloadURL();
            imageUrl2 = await snap2.ref.getDownloadURL();
            imageUrl3 = await snap3.ref.getDownloadURL();
            List<String> images = [imageUrl1, imageUrl2, imageUrl3];
            productService.uploadProduct(
                _currentCategory,
                _currentBrand,
                productNameController.text,
                double.parse(productPriceController.text),
                productDescriptionController.text,
                int.parse(productCountController.text),
                groupValue,
                selectedSize,
                images);
            
            setState(() {
              loading = false;
            });
            Fluttertoast.showToast(msg: 'Product Added', backgroundColor: black).then((value) => _formKey.currentState.reset());
          });
        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: 'select at least one size');
        }
      } else {
        setState(() {
          loading = false;
        });
        scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
          'You have to pick 3 images',
          textAlign: TextAlign.center,
          style: TextStyle(color: grey),
        )));
      }
    }
  }

// ====================================ADDING IMAGES================================
  selectImage(Future<File> pickImage, int imageNumber) async {
    File fileImage = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() {
          _image1 = fileImage;
        });
        break;
      case 2:
        setState(() {
          _image2 = fileImage;
        });
        break;
      case 3:
        setState(() {
          _image3 = fileImage;
        });
        break;
    }
  }

  Widget displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 55, 16, 55),
        child: Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 137,
      );
    }
  }

  Widget displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 55, 16, 55),
        child: Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 137,
      );
    }
  }

  Widget displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 55, 16, 55),
        child: Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 137,
      );
    }
  }
}
