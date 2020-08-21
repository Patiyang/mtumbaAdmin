import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/brandCategoryClothing/brandDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styling.dart';

class AddBrand extends StatefulWidget {
  @override
  _AddBrandState createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final brandController = new TextEditingController();
  final brandFormKey = new GlobalKey<FormState>();
  final BrandService brandService = new BrandService();
  Firestore firestore = Firestore.instance;
  String brandId;
  String email;
  @override
  void initState() {
    super.initState();
    getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            stream: firestore.collection('brands').document(brandId).collection(email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot snap = snapshot.data.documents[index];
                    print('Brand is${snap['brandName']}');
                    return ListTile(
                      title: Text(snap['brandName']),
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
    var alerts = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        alignment: Alignment.center,
        width: 320,
        height: 100,
        child: Form(
          key: brandFormKey,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: brandController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              hintText: 'add brand',
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
            brandService.checkExisting(brandController.text).then((snap) async {
              if (snap.documents.length > 0) {
                Fluttertoast.showToast(msg: 'Failed! Category Already Exists', backgroundColor: grey[800])
                    .then((value) => brandController.clear());
                Navigator.pop(context);
              } else {
                if (brandController.text != null) {
                  await brandService.newBrand(brandController.text);
                }
                Fluttertoast.showToast(msg: 'New brand added successfully', backgroundColor: grey[800]);
                setState(() {
                  getBrands();
                });
                Navigator.pop(context);
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
          icon: Icon(
            Icons.cancel,
            // color: redColor,
          ),
          label: Text('cancel'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alerts);
  }

  getBrands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      brandId = prefs.getString(User.id);
      email = prefs.getString(User.email);
    });

    print(email);
    print(brandId);
  }
}
