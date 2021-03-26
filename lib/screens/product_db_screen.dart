// Copyright (C) 2021 Roman Zubin
//
// This file is part of Honest Calorie.
//
// Honest Calorie is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Honest Calorie is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Honest Calorie.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:honest_calorie/localizations.dart';
import 'package:honest_calorie/types/product.dart';
import 'package:honest_calorie/types/product_filter.dart';
import 'package:honest_calorie/widgets/drawer.dart';
import 'package:honest_calorie/screens/forms/product_edit_screen.dart';
import 'package:honest_calorie/types/product_db_screen_arguments.dart';

import 'package:honest_calorie/main.dart';
import 'package:honest_calorie/widgets/no_data.dart';

class ProductDBScreen extends StatefulWidget {
  static const String routeName = "/product_db";
  @override
  State createState() => new _ProductDBState();
}

class _ProductDBState extends State<ProductDBScreen> {
  ProductFilter filter = new ProductFilter();
  ProductDBScreenArguments args = new ProductDBScreenArguments(false);

  String getProductSubtitle(Product product) {
    String subtitle = product.calories.toString() +
        " " +
        AppLocalizations.of(context).translate("kcal_per") +
        " " +
        product.servingSize.toString() +
        " " +
        product.getLocalizedUnit(context);
    return subtitle;
  }

  @override
  Widget build(BuildContext context) {
    //final Object args = ModalRoute.of(context)!.settings.arguments!;

    return Scaffold(
        drawer: args.isPicker ? null : AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDBEdit(
                    product: new Product(),
                    index: -1,
                    isEditing: false,
                  ),
                ));
            setState(() {});
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(args.isPicker
              ? AppLocalizations.of(context).translate("pick_product")
              : AppLocalizations.of(context).translate("products")),
          leading: args.isPicker
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  // TODO: implement barcode scanner
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: AppLocalizations.of(context).translate("search"),
                    hintText:
                        AppLocalizations.of(context).translate("search_hint"),
                  ),
                  onChanged: (String value) {
                    filter.searchQuery = value;
                    setState(() {});
                  },
                ),
              ),
              FutureBuilder(
                  future: products.getProductsFiltered(filter),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            Product product = products
                                .getProductByIndex(snapshot.data[index]);
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(getProductSubtitle(product)),
                                  onTap: () async {
                                    if (args.isPicker) {
                                      Navigator.pop(context, product);
                                    } else {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDBEdit(
                                                    product: product,
                                                    index: snapshot.data[index],
                                                    isEditing: true,
                                                  )));
                                      setState(() {});
                                    }
                                  },
                                  onLongPress: () {
                                    // TODO: select
                                  },
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ));
                      } else {
                        return NoData(
                          iconData: Icons.fastfood,
                          text: AppLocalizations.of(context)
                              .translate("no_products"),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return NoData(
                          iconData: Icons.error,
                          text: AppLocalizations.of(context)
                              .translate("something_went_wrong"));
                    } else {
                      return Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          )
                        ],
                      ));
                    }
                  }),
              // TODO: сделать пустое место, чтобы было видно что находится за кнопкной добавить
            ],
          ),
        ));
  }
}
