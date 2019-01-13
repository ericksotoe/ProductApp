import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/auth.dart';
import 'pages/product.dart';
import 'pages/products.dart';
import 'pages/products_admin.dart';
//import 'package:flutter/rendering.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainAccentColor = Color.fromRGBO(8, 37, 103, 0.9);

    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepPurple,
          accentColor: mainAccentColor,
          buttonColor: mainAccentColor,

//        fontFamily: 'Oswald'
        ),
//      home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>  !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          return null;
        },
        // this runs if we cant id the named route
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }
}
