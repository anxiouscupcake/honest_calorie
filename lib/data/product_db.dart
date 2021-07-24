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

import 'package:flutter/foundation.dart';
import 'package:honest_calorie/types/product.dart';
import 'package:honest_calorie/types/product_filter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProductDatabase {
  ProductDatabase();

  List<Product> _flist = [];
  bool _isLoaded = false;

  /// Total count of stored products.
  int productCount() {
    return _flist.length;
  }

  /// Returns indexes of products.
  Future<List<int>> getProductsFiltered(ProductFilter filter) async {
    if (!_isLoaded)
      await load();
    
    List<int> list = [];
    filter.searchQuery = filter.searchQuery.toLowerCase();
    for (int i = 0; i < _flist.length; i++) {
      if (filter.searchQuery != "") {
        if (_flist[i].name.toLowerCase().contains(filter.searchQuery)) {
          list.add(i);
        }
      } else {
        list.add(i);
      }
    }
    return list;
  }

  Future<Product?> getProductByName(String productName) async {
    productName = productName.toLowerCase();
    for (Product item in _flist) {
      if (item.name.toLowerCase() == productName) {
        return item;
      }
    }
    return null;
  }

  Product getProductByIndex(int index) {
    return _flist[index];
  }

  Future<bool> _addProduct(Product product) async {
    Product? f = await getProductByName(product.name);
    if (f == null) {
      _flist.add(product);
      return true;
    } else {
      // product already exists
      return false;
    }
  }

  /// Adds given product item to database.
  Future<bool> addProduct(Product product) async {
    bool b = await _addProduct(product);
    if (b) await save();
    return b;
  }

  Future addProductList(List<Product> list) async {
    for (Product item in list) {
      // TODO: это скорее всего сильно замедлит работу, нужно что-то придумать
      await _addProduct(item);
    }
    await save();
    return true;
  }

  // TODO: make this async
  /// Removes given product.
  removeProduct(Product product) {
    _flist.remove(product);
    save();
  }

  // TODO: make this async
  // TODO: what
  /// Replaces given product (product) with another product (withProduct).
  replaceProduct(Product product, Product withProduct) {
    for (int i = 0; i < _flist.length; i++) {
      if (_flist[i] == product) {
        _flist[i] = withProduct;
        break;
      }
    }
    save();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path + "/product-db.json");
  }

  Future<bool> load() async {
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    try {
      //await Future.delayed(const Duration(seconds: 10), () {});
      _flist = [];
      final file = await _localFile;
      List<dynamic> d = await json.decode(file.readAsStringSync());
      _flist = d.map<Product>((f) => Product.fromJson(f)).toList();
      stopwatch.stop();
      debugPrint("DEBUG: Product database loaded in " +
          stopwatch.elapsedMilliseconds.toString() +
          "ms");
      _isLoaded = true;
      return true;
    } catch (e) {
      debugPrint("Caught exception: " + e.toString());
      debugPrint(
          "Failed to read product database file. Creating default one...");
      await _createDefaultDatabase();
      await save();
      stopwatch.stop();
      return false;
    }
  }

  _createDefaultDatabase() async {
    // TODO: implement default db
  }

  Future<File> save() async {
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    final file = await _localFile;
    stopwatch.stop();
    debugPrint("DEBUG: Product database written in " +
        stopwatch.elapsedMilliseconds.toString() +
        "ms");
    Future<File> f = file.writeAsString(jsonEncode(_flist));
    return f;
  }

  /// Debugging function for adding sample data.
  /// amount - how many products will be added.
  Future<bool> generateData(int amount) async {
    debugPrint("DEBUG: Generating " + amount.toString() + " products...");
    List<Product> list = [];
    for (int i = 1; i <= amount; i++) {
      Product product = new Product();
      product.name = "Product #" + i.toString();
      product.notes = "Notes for product item number " + i.toString();
      product.calories = 125 * i;
      product.carbohydrates = 10 * i.toDouble();
      product.fat = 2 * i.toDouble();
      product.protein = 20 * i.toDouble();
      list.add(product);
    }
    addProductList(list);
    debugPrint("DEBUG: Products generated");
    return true;
  }
}
