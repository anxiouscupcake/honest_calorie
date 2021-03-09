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

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nutrition_tracker/localizations.dart';

import 'package:nutrition_tracker/types/product.dart';
import 'package:nutrition_tracker/main.dart';

import 'package:nutrition_tracker/types/exceptions/index_is_null.dart';
import 'package:nutrition_tracker/widgets/category_selector.dart';

class ProductDBEdit extends StatefulWidget {
  final Product product;
  final bool isEditing;
  final int index;

  const ProductDBEdit({
    Key key,
    @required this.product,
    @required this.isEditing,
    this.index,
  }) : super(key: key);

  @override
  _ProductDBEditState createState() => _ProductDBEditState();
}

class _ProductDBEditState extends State<ProductDBEdit> {
  _pickCategory(BuildContext context) async {
    List<String> categoryKeys = ["grams", "ml", "portion"];
    final picked = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategorySelector(
                titleKey: "pick_category",
                categoryKeys: categoryKeys,
              )),
    );
    if (picked != null) {
      setState(() {
        widget.product.servingUnit = picked;
        if (widget.product.servingUnit == "portion") {
          widget.product.servingSize = 1;
        }
        if (widget.product.servingSize == 1 &&
            widget.product.servingUnit != "portion") {
          widget.product.servingSize = 100;
        }
      });
    }
  }

  Future<String> _getData(String code) async {
    var response = await http.get(
        Uri.encodeFull("https://world.openfoodfacts.org/api/v0/product/" + code + ".json"),
        headers: {"Accept": "application/json"});

    setState(() {
      var data = json.decode(response.body);
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing && widget.index == null) {
      throw new IndexIsNull();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing
              ? AppLocalizations.of(context).translate("edit_product")
              : AppLocalizations.of(context).translate("new_product")),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            if (widget.isEditing)
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // TODO: confirmation
                    products.removeProduct(widget.index);
                    Navigator.pop(context);
                  }),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (widget.isEditing) {
                  products.replaceProduct(widget.product, widget.index);
                  Navigator.pop(context);
                } else {
                  if (await products.addProduct(widget.product)) {
                    Navigator.pop(context);
                  } else {
                    // TODO: error message
                    debugPrint("addProduct() returned false");
                  }
                }
              },
            ),
          ],
        ),
        // TODO: сделать заголовки крута
        // TODO: сделать чтобы при значениях типа 14.0 десятая часть убиралась
        // TODO: сделать валидацию данных и обязательные поля
        body: ListView(
          children: <Widget>[
            TextButton(
              child: Text("Scan a barcode"),
              onPressed: () {
                // TODO: implement barcode scanner
                _getData("3017620422003");
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller:
                        TextEditingController(text: widget.product.name),
                    decoration: InputDecoration(
                      icon: Icon(Icons.fastfood),
                      labelText: AppLocalizations.of(context)
                          .translate("product_name"),
                      hintText: AppLocalizations.of(context)
                          .translate("product_name_hint"),
                    ),
                    onChanged: (String value) {
                      widget.product.name = value;
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: widget.product.calories == 0
                            ? ""
                            : widget.product.calories.toString()),
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText:
                          AppLocalizations.of(context).translate("calories"),
                      hintText: AppLocalizations.of(context)
                          .translate("calories_hint"),
                    ),
                    onChanged: (String value) {
                      widget.product.calories = int.tryParse(value);
                    },
                  ),
                  // TODO: make smart spacing
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        margin: EdgeInsets.only(right: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: widget.product.servingSize.toString()),
                          decoration: InputDecoration(
                            icon: Icon(Icons.description),
                            labelText: AppLocalizations.of(context)
                                .translate("serving_size"),
                          ),
                          onChanged: (String value) {
                            widget.product.servingSize = int.tryParse(value);
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(right: 20),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: widget.product.getLocalizedUnit(context)),
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).translate("unit"),
                          ),
                          onTap: () {
                            _pickCategory(context);
                          },
                          onChanged: (String value) {
                            widget.product.servingUnit = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              //margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller:
                        TextEditingController(text: widget.product.notes),
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText:
                          AppLocalizations.of(context).translate("notes"),
                      hintText:
                          AppLocalizations.of(context).translate("notes_hint"),
                    ),
                    onChanged: (String value) {
                      widget.product.notes = value;
                    },
                  ),
                  // TODO: make smart spacing
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.carbohydrates == 0
                                      ? ""
                                      : widget.product.carbohydrates
                                          .toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("carbohydrates"),
                                hintText: AppLocalizations.of(context)
                                    .translate("carbohydrates_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.carbohydrates =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.fat == 0
                                      ? ""
                                      : widget.product.fat.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("fat"),
                                hintText: AppLocalizations.of(context)
                                    .translate("fat_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.fat =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.protein == 0
                                      ? ""
                                      : widget.product.protein.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("protein"),
                                hintText: AppLocalizations.of(context)
                                    .translate("protein_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.protein =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.salt == 0
                                      ? ""
                                      : widget.product.salt.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("salt"),
                                hintText: AppLocalizations.of(context)
                                    .translate("salt_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.salt =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.sugar == 0
                                      ? ""
                                      : widget.product.sugar.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("sugar"),
                                hintText: AppLocalizations.of(context)
                                    .translate("sugar_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.sugar =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.saturatedFat == 0
                                      ? ""
                                      : widget.product.saturatedFat.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("sat_fat"),
                                hintText: AppLocalizations.of(context)
                                    .translate("sat_fat_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.saturatedFat =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.fibre == 0
                                      ? ""
                                      : widget.product.fibre.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("fibre"),
                                hintText: AppLocalizations.of(context)
                                    .translate("fibre_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.fibre =
                                    double.tryParse(value) ?? 0;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: widget.product.sodium == 0
                                      ? ""
                                      : widget.product.sodium.toString()),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("sodium"),
                                hintText: AppLocalizations.of(context)
                                    .translate("sodium_hint"),
                              ),
                              onChanged: (String value) {
                                widget.product.sodium =
                                    int.tryParse(value) ?? 0;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
