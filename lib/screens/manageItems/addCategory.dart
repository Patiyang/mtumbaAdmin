import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/services/brandCategoryClothing/categoryDatabase.dart';
import 'package:mtumbaAdmin/styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _categoryFormKey = GlobalKey<FormState>();
  final categoryController = new TextEditingController();
  final CategoryService _categoryService = CategoryService();
  Firestore firestore = Firestore.instance;
  QuerySnapshot snapshot;
  String categoryId;
  String email;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: () => categoryAlert(),
            elevation: 0,
            backgroundColor: orange[300],
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
          StreamBuilder(
            stream: firestore.collection('categories').document(categoryId).collection(email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot snap = snapshot.data.documents[index];
                    print('Category is ${snap['categoryName']}');
                    return ListTile(
                      title: Text(snap['categoryName']),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  categoryAlert() {
    // checkBrand = _categoryService.checkExisting(categoryController.text);
    var alerts = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        alignment: Alignment.center,
        width: 320,
        height: 100,
        child: Form(
          key: _categoryFormKey,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: categoryController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              hintText: 'add Category',
              hintStyle: TextStyle(color: Colors.grey[350]),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'brand cannot be empty';
              }
              return null;
            },
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          color: grey[100],
          onPressed: () {
            _categoryService.checkExisting(categoryController.text).then((snap) async {
              if (snap.documents.length > 0) {
                Fluttertoast.showToast(msg: 'Failed! Category Already Exists', backgroundColor: grey[800])
                    .then((value) => categoryController.clear());
                Navigator.pop(context);
              } else {
                await _categoryService.newCategory(categoryController.text);
                Fluttertoast.showToast(msg: '${categoryController.text} added successfully', backgroundColor: grey[800])
                    .then((value) => categoryController.clear());
                setState(() {
                  getCategories();
                });
                // Navigator.pop(context);
                categoryController.clear();
              }
            });
          },
          icon: Icon(
            Icons.check,
            // color: redColor,
          ),
          label: Text('done'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        FlatButton.icon(
          color: grey[100],
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel),
          label: Text('cancel'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alerts);
  }

  getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      categoryId = prefs.getString(User.id);
      email = prefs.getString(User.email);
    });
  }
}
