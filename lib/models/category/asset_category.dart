import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

abstract class AssetCategory {
  AssetCategoryId id;

  AssetCategoryShortName shortName;

  AssetCategoryName name;

  Icon icon;

  AssetCategory(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.icon});
}
