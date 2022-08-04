import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetUsdStockCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetUsdStockCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.usdStock;

  @override
  AssetCategoryName name = AssetCategoryName.usdStockName;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.usdStockShortName;

  @override
  Icon icon = const Icon(
    Icons.monetization_on,
    size: 16,
    color: Colors.teal,
  );
}
