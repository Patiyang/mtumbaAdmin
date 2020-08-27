import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/screens/manageItems/addBrand.dart';
import 'package:mtumbaAdmin/screens/manageItems/addCategory.dart';
import 'package:mtumbaAdmin/screens/manageItems/addProduct.dart';
import 'package:mtumbaAdmin/styling.dart';
import 'package:mtumbaAdmin/widgets/customButton.dart';

enum Pages { category, clothing, brand }

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Pages selectedPage = Pages.category;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 7),
          color: grey[100],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomFlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
                  text: 'Add Category',
                  color: selectedPage == Pages.category ? orange[300] : grey[300],
                  callback: () {
                    setState(() {
                      selectedPage = Pages.category;
                    });
                  }),
              CustomFlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
                  text: 'Add Brand',
                  color: selectedPage == Pages.brand ? orange[300] : grey[300],
                  callback: () {
                    setState(() {
                      selectedPage = Pages.brand;
                    });
                  }),
              CustomFlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
                  text: 'Add Clothing',
                  color: selectedPage == Pages.clothing ? orange[300] : grey[300],
                  callback: () {
                    setState(() {
                      selectedPage = Pages.clothing;
                    });
                  }),
            ],
          ),
        ),
        Expanded(child: selectedOption())
      ],
    );
  }

  Widget selectedOption() {
    switch (selectedPage) {
      case Pages.category:
        return AddCategory();
        break;
      case Pages.brand:
        return AddBrand();
        break;
      case Pages.clothing:
        return AddClothing();
      default:
        return Container();
    }
  }
}
