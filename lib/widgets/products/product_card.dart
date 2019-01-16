import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../ui_elements/title_default.dart';
import 'address_tag.dart';
import 'price.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(
              width: 9.0,
            ),
            PriceTag(product.price.toString())
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          onPressed: () {
            model.selectProduct(model.allProducts[productIndex].id);
            Navigator.pushNamed<bool>(
                context, '/product/' + model.allProducts[productIndex].id).then((_) => model.selectProduct(null));
          },
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: () {
            model.selectProduct(model.allProducts[productIndex].id);
            model.toggleProductFavoriteStatus();
          },
          icon:
              Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          color: Colors.red,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/food.jpg'),
            ),
          ),
          _buildTitlePriceRow(),
          AdressTag(product.location.address),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
