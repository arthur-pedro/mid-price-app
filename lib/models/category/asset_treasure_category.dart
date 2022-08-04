import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetTreasureCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetTreasureCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.treasure;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.treasureShortName;

  @override
  AssetCategoryName name = AssetCategoryName.treasureName;

  @override
  Icon icon = const Icon(
    Icons.balance_outlined,
    size: 16,
    color: Colors.deepPurple,
  );
}
