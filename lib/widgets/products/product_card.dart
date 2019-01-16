import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../ui_elements/title_default.dart';
import 'address_tag.dart';
import 'price.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  Widget _buildTitlePriceRow() {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: TitleDefault(product.title)),
            Flexible(
              child: SizedBox(
                width: 9.0,
              ),
            ),
            Flexible(child: PriceTag(product.price.toString()))
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          onPressed: () {
            model.selectProduct(product.id);
            Navigator.pushNamed<bool>(
                context, '/product/' + product.id).then((_) => model.selectProduct(null));
          },
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: Icon(product.isFavorite
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            // model.selectProduct(product.id); => Don't do this anymore
            model.toggleProductFavoriteStatus(product); // Pass the product used in this card
          },
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
