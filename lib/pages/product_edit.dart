import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/form_inputs/location.dart';

import '../scoped-models/main.dart';
import '../widgets/helpers/ensure-visible.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextFormField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelText: "Product Title",
        ),
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          if ( value.isEmpty || value.length < 3 ) {
            return "Title is required and should be 5+ characters long";
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextFormField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(
          labelText: "Description",
        ),
        maxLines: 4,
        initialValue: product == null ? '' : product.description,
        validator: (String value) {
          if ( value.isEmpty || value.length < 7 ) {
            return "Description is required and should be 10+ characters long";
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextFormField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(
          labelText: "Price",
        ),
        keyboardType: TextInputType.number,
        initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
          if ( value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value) ) {
            return "Price is required and should be a valid number";
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
          textColor: Colors.white,
          child: Text("Save"),
          onPressed: () =>
              _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: targetWidth,
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextFormField(product),
              _buildDescriptionTextFormField(product),
              _buildPriceTextFormField(product),
              SizedBox(
                height: 10.0,
              ),
              LocationInput(),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),

//        GestureDetector(
//          onTap: _submitForm,
//          child: Container(
//            color: Colors.green,
//            padding: EdgeInsets.all(5.0),
//            child: Text("My Button"),
//          ),
//        )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct,
      Function setSelectedProduct,
      [int selectedProductIndex]) {
    if ( !_formKey.currentState.validate() ) {
      return;
    }
    _formKey.currentState.save();
    if ( selectedProductIndex == -1 ) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {
        if ( success ) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Something went wrong "),
              content: Text("Please try again"),
              actions: <Widget>[
                FlatButton(onPressed: () => Navigator.of(context).pop(),
                  child: Text("Okay"),)
              ],);
          });
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) =>
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
        _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
            appBar: AppBar(title: Text("Edit Product")), body: pageContent);
      },
    );
  }
}
