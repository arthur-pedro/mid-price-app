import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetUsdFiiCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetUsdFiiCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.usdFii;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.usdFiiShortName;

  @override
  AssetCategoryName name = AssetCategoryName.usdFiiName;

  @override
  Icon icon = const Icon(
    Icons.business,
    size: 16,
    color: Colors.deepOrange,
  );
}
