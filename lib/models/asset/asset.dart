import 'dart:developer';

import 'package:midprice/database/asset/asset_bo.dart';
import 'package:midprice/models/category/asset_brl_etf_category.dart';
import 'package:midprice/models/category/asset_brl_fii_category.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_list.dart';
import 'package:midprice/models/category/asset_cdb_category.dart';
import 'package:midprice/models/category/asset_others_category.dart';
import 'package:midprice/models/category/asset_treasure_category.dart';
import 'package:midprice/util/parser.dart';

class Asset {
  @override
  bool operator ==(Object other) => other is Asset && other.name == name;

  @override
  int get hashCode => name.hashCode;

  int? id;

  String name;

  double price;

  AssetCategory category;

  Asset(
      {this.id,
      required this.name,
      required this.price,
      required this.category});

  static Asset fromJson(Map<String, Object?> json) => Asset(
      id: json[AssetBO.id] as int,
      name: json[AssetBO.name] as String,
      price: Parser.stringToDouble(json[AssetBO.price] as String),
      category: getCategory(json[AssetBO.category] as String));

  static Map<String, Object?> toJson(Asset asset) => {
        AssetBO.id: asset.id,
        AssetBO.name: asset.name.trim(),
        AssetBO.price: Parser.doubleToString(asset.price).trim(),
        AssetBO.category: asset.category.id.name
      };

  static AssetCategory getCategory(String category) {
    return AssetCategoryList.all()
        .firstWhere((element) => element.id.name == category);
    ;
  }
}
